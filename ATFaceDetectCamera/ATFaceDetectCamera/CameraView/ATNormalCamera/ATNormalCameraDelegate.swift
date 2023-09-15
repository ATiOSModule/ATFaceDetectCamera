//
//  ATNormalCameraDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import UIKit
import AVFoundation
import Vision

public struct ATNormalResult {
    
    public let faceObservation: VNFaceObservation
    public let faceImage: UIImage
    public let fullImage: UIImage
    public let boundingBox: CGRect
    
}


public protocol ATNormalCameraDelegate: ATCameraDelegate {
    
    func cameraViewOutput(sender: ATCameraViewInterface, result: ATNormalResult)
    
    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, invalidType: ATFaceState)
    
}
