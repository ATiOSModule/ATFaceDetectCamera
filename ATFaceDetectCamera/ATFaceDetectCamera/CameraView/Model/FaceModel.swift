//
//  FaceModel.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 22/08/2023.
//

import Foundation

public struct FacePoseModel {
    var roll: Double
    var pitch: Double
    var yaw: Double
    
    init() {
        self.roll = 0.0
        self.pitch = 0.0
        self.yaw = 0.0
    }
    
}
