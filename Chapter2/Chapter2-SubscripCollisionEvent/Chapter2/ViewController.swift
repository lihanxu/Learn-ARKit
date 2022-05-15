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
        addGesture()
    }
    
    private func initARViewInfo() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config)
    }
    
    /// 添加点击手势
    private func addGesture () {
        let tapG = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        self.arView.addGestureRecognizer(tapG)
    }
    
    /// 响应点击手势
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer?) {
        // 获取点击位置
        guard let pos = sender?.location(in: self.arView) else { return }
        // 创建射线查询
        guard let query = arView.makeRaycastQuery(from: pos, allowing: .estimatedPlane, alignment: .horizontal) else { return }
        // 获取射线碰撞结果
        guard let res = self.arView.session.raycast(query).first else { return }
        // 转换坐标系
        let transform = Transform(matrix: res.worldTransform)
        // 创建自定义实体
        let box = CustomEntity(color: .white, position: transform.translation)
        // 订阅碰撞检测事件
        box.addCollisions(scene: self.arView.scene)
        // 为box添加手势
        self.arView.installGestures(.all, for: box)
        // 添加box到场景中
        self.arView.scene.addAnchor(box)
    }
}
