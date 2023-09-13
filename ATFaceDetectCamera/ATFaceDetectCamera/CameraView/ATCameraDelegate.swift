//
//  ATCameraDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 14/09/2023.
//

import Foundation

public enum DelegateError: Error {
    case  notConformToATNormalCameraDelegate
    case  notConformToATTrueDepthCameraDelegate
    case  notConformToATARKitCameraDelegate
}

public protocol ATCameraDelegate: NSObject {
   
}
