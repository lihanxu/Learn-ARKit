//
//  ViewController.swift
//  Chapter2
//
//  Created by anker on 2022/5/14.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initARViewInfo()
    }
    
    /// 初始化 ARView 相关信息
    private func initARViewInfo() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config)
        arView.session.delegate = arView
        // 通过设置 debugOptions 属性可以以可视化方式查看 ARKit 运行时的状态信息，如特征点、平面、场景几何网格、世界坐标原点等。
//        arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showFeaturePoints]
        arView.createPlane()
    }
}

/// 平面网格
let planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)
/// 平面材质
var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
/// 平面实体
let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
/// 锚实体
let planeAnchor = AnchorEntity(plane: .horizontal, classification: .floor, minimumBounds: [0.1, 0.1])

extension ARView: ARSessionDelegate {
    /// 创建一个平面并添加到scene中
    func createPlane() {
        // 创建一个 平面锚实体
        let planeAnchor = AnchorEntity(plane: .horizontal)
        do {
            // 设置平面材料颜色
            planeMaterial.baseColor = .texture(try .load(named: "Surface_DIFFUSE.png"))
            planeMaterial.tintColor = UIColor.yellow.withAlphaComponent(0.9999)
            // 将平面实体添加到平面锚中
            planeAnchor.addChild(planeEntity)
            // 添加平面锚至场景中
            self.scene.addAnchor(planeAnchor)
        } catch {
            print("找不到文件")
        }
    }
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        let err = error as NSError
        if err.code == ARError.worldTrackingFailed.rawValue {
            print("由于运动跟踪失败的错误可恢复")
        } else {
            print("错误不可恢复，code = \(err.code)，错误描述：\(err.localizedDescription)")
        }
    }
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // 获取场景中的第一个锚
        guard let anchor = anchors[0] as? ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            // 使用获取到的锚的坐标来修改平面锚实体的网格
            planeEntity.model?.mesh = MeshResource.generatePlane(width: anchor.extent.x, depth: anchor.extent.z)
            // 根据获取到的锚的移动信息来移动平面锚
            planeEntity.setTransformMatrix(anchor.transform, relativeTo: nil)
        }
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // 获取场景中的第一个锚
        guard let anchor = anchors[0] as? ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            // 使用获取到的锚的坐标来修改平面锚实体的网格
            planeEntity.model?.mesh = MeshResource.generatePlane(width: anchor.extent.x, depth: anchor.extent.z)
            // 根据获取到的锚的移动信息来移动平面锚
            planeEntity.setTransformMatrix(anchor.transform, relativeTo: nil)
        }
    }
}

