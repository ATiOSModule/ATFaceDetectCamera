//
//  ATTrueDepthCameraDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 14/09/2023.
//

import UIKit
import AVFoundation
import Vision

public struct ATTrueDepthResult {
    
    public let faceObservation: VNFaceObservation
    public let depthData: AVDepthData
    public let faceImage: UIImage
    public let fullImage: UIImage
    public let boundingBox: CGRect
    
}


public protocol ATTrueDepthCameraDelegate: ATCameraDelegate {
    
    func cameraViewOutput(sender: ATCameraViewInterface, result: ATTrueDepthResult)

    func cameraViewOutput(sender: ATCameraViewInterface, invalidFace: VNFaceObservation, depthData: AVDepthData, invalidType: ATFaceState)
    
}
