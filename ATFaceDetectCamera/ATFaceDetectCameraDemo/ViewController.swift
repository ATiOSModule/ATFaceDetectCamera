//
//  ViewController.swift
//  ATFaceDetectCameraDemo
//
//  Created by Wee on 09/08/2023.
//

import UIKit
import ATFaceDetectCamera
import ATBaseExtensions
import Vision

class ViewController: UIViewController {

    let cameraView: ATCameraViewInterface = ATCameraView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.fixInView(self.view)
        cameraView.setDelegate(self)
        
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

extension ViewController: ATCameraViewDelegate {
    
    func cameraViewOutput(sender: ATCameraViewInterface, faceImage: UIImage, fullImage: UIImage, boundingBox: CGRect) {
        print("Success: \(boundingBox)")
    }
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, invalidType: ATCameraView.FaceState) {
        print("SuccessNot: \(invalidType)")
    }
    
}
