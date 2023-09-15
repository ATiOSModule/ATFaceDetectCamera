//
//  ATFaceDetectCameraHandler.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import Foundation

public protocol ATIFaceDetectCameraHandler {
    func createNormalCamera() -> ATCameraViewInterface
    func createTrueDepthCamera() -> ATCameraViewInterface
}

public final class ATFaceDetectCameraHandler: ATIFaceDetectCameraHandler {
   
    static public let shared: ATIFaceDetectCameraHandler = {
        return ATFaceDetectCameraHandler()
    }()
    
    private init() {}
    
}

public extension ATFaceDetectCameraHandler {
    
    func createNormalCamera() -> ATCameraViewInterface {
        
        let cameraView = ATNormalCameraView()
        return cameraView
        
    }
    
    func createTrueDepthCamera() -> ATCameraViewInterface {
        
        let cameraView = ATTrueDepthCameraView()
        return cameraView
        
    }
    
}
