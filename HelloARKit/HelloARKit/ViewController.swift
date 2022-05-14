//
//  ViewController.swift
//  HelloARKit
//
//  Created by anker on 2022/2/19.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var trackingStatus: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSceneView()
        initScene()
        initARSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [
            //ARSCNDebugOptions.showFeaturePoints,
            //ARSCNDebugOptions.showWorldOrigin,
            //SCNDebugOptions.showBoundingBoxes,
            //SCNDebugOptions.showWireframe
        ]
    }
    
    private func initScene() {
        let scene = SCNScene(named: "ARResource.scnassets/SceneKit Scene.scn")!
//        scene.isPaused = false
        sceneView.scene = scene
//        scene.lightingEnvironment.contents = "ARResource.scnassets/Textures/Environment_cube.jpg"
//        scene.lightingEnvironment.intensity = 2
    }
    
    private func initARSession() {
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        sceneView.session.run(config)
    }
    
    // MARK: - Actions
    
    @IBAction func styleButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    // MARK: - ARSCNViewDelegate
    

}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.statusLabel.text = self.trackingStatus
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            trackingStatus = "Tacking:  Not available!"
        case .normal:
            trackingStatus = "Tracking: All Good!"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                self.trackingStatus = "Tracking: Limited due to excessive motion!"
                break
            case .insufficientFeatures:
                self.trackingStatus = "Tracking: Limited due to insufficient features!"
                break
            case .initializing:
                self.trackingStatus = "Tracking: Initializing..."
                break
            case .relocalizing:
                self.trackingStatus = "Tracking: Relocalizing..."
            @unknown default:
                fatalError()
            }
        }
    }
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            trackingStatus = "AR Session Failure: \(error)"
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            trackingStatus = "AR Session Was Interrupted!"
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            trackingStatus = "AR Session Interruption Ended"
        }
}
