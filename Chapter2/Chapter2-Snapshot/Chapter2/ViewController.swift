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
        addSnapButtons()
    }
    
    /// 初始化ARView信息
    private func initARViewInfo() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config)
        arView.createPlane()
    }
    
    private func addSnapButtons() {
        // 添加截屏按钮，截屏包含AR信息
        let button1 = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button1.setTitle("截屏", for: .normal)
        button1.backgroundColor = .red
        button1.tag = 0
        button1.addTarget(self, action: #selector(snap(_:)), for: .touchUpInside)
        self.arView.addSubview(button1)
        
        // 添加截屏按钮，截屏不包含AR信息
        let button2 = UIButton(frame: CGRect(x: 250, y: 100, width: 100, height: 50))
        button2.setTitle("截屏", for: .normal)
        button2.backgroundColor = .green
        button2.tag = 1
        button2.addTarget(self, action: #selector(snap(_:)), for: .touchUpInside)
        self.arView.addSubview(button2)
    }
    
    @objc private func snap(_ sender: UIButton) {
        if sender.tag == 0 {
            arView.snapShotAR()
        } else if sender.tag == 1 {
            arView.snapShotCamera()
        }
    }
}

extension ARView {
    /// 创建一个平面
    func createPlane() {
        let planeEntity = AnchorEntity(plane: .horizontal)
        let mesh = MeshResource.generateBox(size: 0.2)
        var material = SimpleMaterial(color: .white, isMetallic: false)
        do {
            material.baseColor = .texture(try .load(named: "Box_Texture.jpg"))
            let cubEntity = ModelEntity(mesh: mesh, materials: [material])
            cubEntity.generateCollisionShapes(recursive: false)
            planeEntity.addChild(cubEntity)
            self.scene.addAnchor(planeEntity)
            self.installGestures(.all, for: cubEntity)
        } catch {
            print("没有找到文件")
        }
    }
    
    /// 截屏
    ///
    /// 截屏包含AR信息
    func snapShotAR() {
        // 方法一：包含屏幕所有元素（包含截屏按钮）
        self.snapshot(saveToHDR: false) { image in
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        // 方法二：不包含非AR控件（不包含截屏按钮）
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let uiimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(uiimage!, self, #selector(imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 截屏
    ///
    /// 截屏不包含AR信息，只保留摄像头原始数据
    func snapShotCamera() {
        guard let pixelBuffer = self.session.currentFrame?.capturedImage else { return }
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer),
        context = CIContext(options: nil),
        cgimage = context.createCGImage(ciimage, from: ciimage.extent),
        uiimage = UIImage(cgImage: cgimage!, scale: 1.0, orientation: .right)
        UIImageWriteToSavedPhotosAlbum(uiimage, self, #selector(imageSaveHandler(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func imageSaveHandler(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            print("保存图片成功")
        } else {
            print("保存图片失败")
        }
    }
}
