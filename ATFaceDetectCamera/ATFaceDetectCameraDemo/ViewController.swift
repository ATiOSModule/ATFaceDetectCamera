//
//  ViewController.swift
//  ATFaceDetectCameraDemo
//
//  Created by Wee on 09/08/2023.
//

import UIKit
import ATFaceDetectCamera
import Vision
import AVFoundation

class ViewController: UIViewController {

    let cameraView: ATCameraViewInterface = ATFaceDetectCameraHandler.shared.createTrueDepthCamera()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.fixInView(self.view)
        
        do {
            try cameraView.setDelegate(self)
        } catch let err as NSError {
            print(err)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: { [weak self] in
            self?.cameraView.startCamera()
        })
        
    }


}

extension ViewController: ATTrueDepthCameraDelegate {
    func cameraViewOutput(sender: ATCameraViewInterface, result: ATTrueDepthResult) {
        
    }
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, depthData: AVDepthData, invalidType: ATFaceState) {
        
    }
    
    
}
