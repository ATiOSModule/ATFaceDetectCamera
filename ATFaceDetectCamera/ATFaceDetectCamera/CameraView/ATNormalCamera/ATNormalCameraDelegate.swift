//
//  ATNormalCameraDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import UIKit
import AVFoundation
import Vision

public protocol ATNormalCameraDelegate: ATCameraDelegate {
    
    func cameraViewOutput(sender: ATCameraViewInterface, faceImage: UIImage, fullImage: UIImage, boundingBox: CGRect)
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, invalidType: ATFaceState)
    
}
