//
//  ATFaceValidator.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 15/09/2023.
//

import Foundation
import Vision

internal final class ATFaceValidator {
    
    struct FaceResult {
        var isValid: Bool
        var faceState: ATFaceState
        
        init(isValid: Bool, faceState: ATFaceState) {
            self.isValid = isValid
            self.faceState = faceState
        }
        
    }
    
    func checkValidHeadPoseEstimation(result: VNFaceObservation) -> ATFaceValidator.FaceResult {
        
        let roll: Double = result.roll?.doubleValue ?? 0
        let yaw: Double = result.yaw?.doubleValue ?? 0
        var pitch: Double = 0
        if #available(iOS 15.0, *) {
            pitch = result.pitch?.doubleValue ?? 0
        }
        
        let resultRollDegress: Double = 180.0 * roll / Double.pi
        let resultYawDegress: Double = 180.0 * yaw / Double.pi
        let resultPitchDegress: Double = 180.0 * pitch / Double.pi
        
//        print("Roll : \(resultRollDegress) ~~~~~ Pitch : \(resultPitchDegress)  ~~~~~ Yaw : \(resultYawDegress)")
     
        if abs(resultRollDegress) > 20 {
            
            if resultRollDegress > 0 {
                return FaceResult(isValid: false, faceState: .faceTooLeaningLeft)
            } else {
                return FaceResult(isValid: false, faceState: .faceTooLeaningRight)
            }
            
        }
        
        if abs(resultYawDegress) > 20 {
            
            if resultYawDegress > 0 {
                return FaceResult(isValid: false, faceState: .faceTooLeaningRight)
            } else {
                return FaceResult(isValid: false, faceState: .faceTooLeaningLeft)
            }
            
        }
        
        if abs(resultPitchDegress) > 15 {
            
            if abs(resultPitchDegress) > 0 {
                return FaceResult(isValid: false, faceState: .faceTooAlignDown)
            } else {
                return FaceResult(isValid: false, faceState: .faceTooAlignUp)
            }
            
        }
        
        return FaceResult(isValid: true, faceState: .validFace)
        
    }
    
    func checkValidFaceBoundRatio(result: VNFaceObservation) -> ATFaceValidator.FaceResult {

        let ratio = Int(result.boundingBox.width * 100)

        if ratio < 30 {
            return FaceResult(isValid: false, faceState: .faceTooSmall)
        }
        
        if ratio > 60 {
            return FaceResult(isValid: false, faceState: .faceTooBig)
        }
        
        return FaceResult(isValid: true, faceState: .validFace)
        
    }
    
    func checkValidCenterFace(result: VNFaceObservation) -> ATFaceValidator.FaceResult {
        
        let resuldCenterX = result.boundingBox.midX
        let resuldCenterY = result.boundingBox.midY
        
        if abs(resuldCenterX - 0.5) > 0.1 || abs(resuldCenterY - 0.5) > 0.1 {
            return FaceResult(isValid: false, faceState: .faceIsNotCenter)
        }
        
        return FaceResult(isValid: true, faceState: .validFace)
        
    }
    
    func fullyCheckFaceValidation(result: VNFaceObservation) -> ATFaceValidator.FaceResult {
        
        let centerFaceResult = self.checkValidCenterFace(result: result)
        if centerFaceResult.isValid == false {
            return FaceResult(isValid: false, faceState: centerFaceResult.faceState)
        }
        
        let ratioFaceResult = self.checkValidFaceBoundRatio(result: result)
        if ratioFaceResult.isValid == false {
            return FaceResult(isValid: false, faceState: ratioFaceResult.faceState)
        }
        
        let poseEstimationResult = self.checkValidHeadPoseEstimation(result: result)
        if poseEstimationResult.isValid == false {
            return FaceResult(isValid: false, faceState: poseEstimationResult.faceState)
        }
        
        return FaceResult(isValid: true, faceState: .validFace)
        
    }
    
}
