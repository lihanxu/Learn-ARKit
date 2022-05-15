//
//  ViewController.swift
//  Chapter2
//
//  Created by anker on 2022/5/15.
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
        arView.addCoaching()
    }
    
}

extension ARView: ARCoachingOverlayViewDelegate {
    /// 添加引导页
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView(frame: UIScreen.main.bounds)
        self.addSubview(coachingOverlay)
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // 引导完成后放置一个盒子
        self.placeBox()
    }
    
    func placeBox() {
        let mesh = MeshResource.generateBox(size: 0.15)
        var material = SimpleMaterial(color: .white, isMetallic: false)
        let entity = AnchorEntity(plane: .horizontal)
        do {
            material.baseColor = .texture(try .load(named: "Box_Texture.jpg"))
            material.tintColor = .white.withAlphaComponent(0.9999)
            let boxEntity = ModelEntity(mesh: mesh, materials: [material])
            entity.addChild(boxEntity)
            self.scene.addAnchor(entity)
        } catch {
            print("找不到文件")
        }
    }
}

