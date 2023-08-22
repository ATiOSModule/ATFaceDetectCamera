//
//  ATCameraView+AVCaptureDataOutputSynchronizerDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 18/08/2023.
//

import Foundation
import UIKit
import AVFoundation
import Vision

extension ATCameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        self.detectFace(from: sampleBuffer, pixelBuffer: imageBuffer)
        
    }
    
}

extension ATCameraView {
    
    fileprivate func detectFace(from sampleBuffer: CMSampleBuffer, pixelBuffer: CVPixelBuffer) {
        
        if self.startCaptureFace == false {
            return
        }
        
        let faceDispatchGroup = DispatchGroup()
        
        var faceRectResults: [VNFaceObservation] = []
        
        //VNDetectFaceRectanglesRequest to get pitch
        faceDispatchGroup.enter()
        let faceDetectRectangleRequest = VNDetectFaceRectanglesRequest() { (request: VNRequest, error: Error?) in
            
            if let results = request.results as? [VNFaceObservation] {
                faceRectResults = results
            }
            faceDispatchGroup.leave()
            
        }
        
        //VNDetectFaceLandmarksRequest to get roll, yaw, and boundingBox
//        faceDispatchGroup.enter()
//        let faceDetectionLandmarRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
//
//            if let results = request.results as? [VNFaceObservation] {
//                faceLandmarkResults = results
//            }
//            faceDispatchGroup.leave()
//
//        })
        
        //Handle face response after all request finish
        faceDispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let result = faceRectResults.first else {
                return
            }
            
            let confidence = result.confidence
            if confidence > 0.5 {
                self?.handleValidFace(from: sampleBuffer, pixelBuffer: pixelBuffer, result: result)
            }
            
        }
        
        //Begin request
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? imageRequestHandler.perform([faceDetectRectangleRequest])
        
    }
    
    fileprivate func handleValidFace(from sampleBuffer: CMSampleBuffer, pixelBuffer: CVPixelBuffer, result: VNFaceObservation) {
        
        if checkValidCenterFace(result: result) == false {
            return
        }
        
        if checkValidFaceBoundRatio(result: result) == false {
            return
        }
        
        if checkValidHeadPoseEstimation(result: result) == false {
            return
        }
        
        self.captureFace(from: sampleBuffer, pixelBuffer: pixelBuffer, result: result)
       
    }
    
    fileprivate func captureFace(from sampleBuffer: CMSampleBuffer, pixelBuffer: CVPixelBuffer, result: VNFaceObservation) {
        
        guard let fullImage: UIImage = UIImage(pixelBuffer: pixelBuffer),
              let fullCGImage = fullImage.cgImage  else {
            return
        }
        
        guard let flipFullCGImage = fullCGImage.rotating(to: .upMirrored),
              let faceCGImage = fullCGImage.cropImage(objectObservation: result)?.rotating(to: .upMirrored) else {
            return
        }
        
        let faceImage = UIImage(cgImage: faceCGImage)
        let flipFullImage = UIImage(cgImage: flipFullCGImage)
        
        self.delegate?.cameraViewOutput(sender: self,
                                        faceImage: faceImage,
                                        fullImage: flipFullImage,
                                        boundingBox: result.boundingBox)
//        self.stopCamera()
        
    }
    
}

//MARK: Handle Valid Face
extension ATCameraView {
    
    ///Handle face rol-pitch-yall
    fileprivate func checkValidHeadPoseEstimation(result: VNFaceObservation) -> Bool {
        
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
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooLeaningRight)
            } else {
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooLeaningLeft)
            }
            
            return false
        }
        
        if abs(resultYawDegress) > 20 {
            
            if resultYawDegress > 0 {
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooLeaningRight)
            } else {
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooLeaningLeft)
            }
            
            return false
        }
        
        if abs(resultPitchDegress) > 15 {
            
            if abs(resultPitchDegress) > 0 {
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooAlignDown)
            } else {
                self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooAlignUp)
            }
            
            return false
        }
        
        return true
        
    }
    
    fileprivate func checkValidFaceBoundRatio(result: VNFaceObservation) -> Bool {

        let ratio = Int(result.boundingBox.width * 100)

        if ratio < 30 {
            
            self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooSmall)
            return false
        }
        
        if ratio > 60 {
            self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceTooBig)
            return false
        }
        
        return true
    }
    
    fileprivate func checkValidCenterFace(result: VNFaceObservation) -> Bool {
        
        let resuldCenterX = result.boundingBox.midX
        let resuldCenterY = result.boundingBox.midY
        
        if abs(resuldCenterX - 0.5) > 0.1 || abs(resuldCenterY - 0.5) > 0.1 {
            self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: .faceIsNotCenter)
            return false
        }
        
        return true
        
    }
    
}
