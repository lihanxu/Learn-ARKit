//
//  CustomEntity.swift
//  Chapter2
//
//  Created by anker on 2022/5/15.
//

import Foundation
import RealityKit
import UIKit
import Combine

class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
    /// 订阅数组，用于存储订阅
    private var subscripts: [Cancellable] = []
    
    /// 初始化
    /// - parameter color: 实体颜色
    ///
    /// 初始化一个指定颜色的实体
    required init(color: UIColor) {
        super.init()
        // 创建碰撞组件
        self.components[CollisionComponent.self] = CollisionComponent(shapes: [.generateBox(size: [0.1, 0.1, 0.1])], mode: .default, filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1)))
        // 创建模型组件
        self.components[ModelComponent.self] = ModelComponent(mesh: .generateBox(size: [0.1, 0.1, 0.1]), materials: [SimpleMaterial(color: color, isMetallic: false)])
    }
    
    /// 初始化
    /// - parameter color: 实体颜色
    /// - parameter position: 实体位置
    ///
    /// 初始化一个指定颜色和位置的实体
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// 添加碰撞检测
    /// - parameter scene: 实体所在的场景
    ///
    /// 订阅碰撞开始和结束事件，当事件触发时修改实体的状态。
    func addCollisions(scene: Scene) {
        // 订阅碰撞开始事件
        let beganSubscription = scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            // 检测发生碰撞的实体是否是 CustomEntity
            guard let box = event.entityA as? CustomEntity else { return }
            // 修改实体颜色
            box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
        }
        subscripts.append(beganSubscription)
        
        // 订阅碰撞结束事件
        let endSubScription = scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
            // 检测发生碰撞的实体是否是 CustomEntity
            guard let box = event.entityA as? CustomEntity else { return }
            // 修改实体颜色
            box.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
        }
        subscripts.append(endSubScription)
        
    }
}
