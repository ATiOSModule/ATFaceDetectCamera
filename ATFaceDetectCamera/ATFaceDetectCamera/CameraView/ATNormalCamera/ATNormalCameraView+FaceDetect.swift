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

extension ATNormalCameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        self.detectFace(from: sampleBuffer, pixelBuffer: imageBuffer)
        
    }
    
}

extension ATNormalCameraView {
    
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
        
        let faceValidationResult = faceValidator.fullyCheckFaceValidation(result: result)
        if faceValidationResult.isValid == false {
            self.delegate?.cameraViewOutput(sender: self, invalidFace: result, invalidType: faceValidationResult.faceState)
            return
        }
        
        self.captureFace(from: sampleBuffer,
                         pixelBuffer: pixelBuffer,
                         result: result)
       
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
        
        let capturedFaceResult: ATNormalResult = ATNormalResult(faceObservation: result,
                                                                faceImage: faceImage,
                                                                fullImage: flipFullImage,
                                                                boundingBox: result.boundingBox)
        
        self.delegate?.cameraViewOutput(sender: self, result: capturedFaceResult)
        
    }
    
}
