//
//  ViewController.swift
//  ATFaceDetectCameraDemo
//
//  Created by Wee on 09/08/2023.
//

import UIKit
import ATFaceDetectCamera
import ATBaseExtensions

class ViewController: UIViewController {

    let cameraView = ATCameraView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.fixInView(self.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startCamera()
    }


}

