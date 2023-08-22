//
//  ATCameraView+AVCaptureDataOutputSynchronizerDelegate.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 18/08/2023.
//

import Foundation
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
    
    func detectFace(from sampleBuffer: CMSampleBuffer, pixelBuffer: CVImageBuffer) {
        
        let faceDispatchGroup = DispatchGroup()
        
        var faceLandmarkResults: [VNFaceObservation] = []
       
        //VNDetectFaceLandmarksRequest to get roll, yaw, and boundingBox
        faceDispatchGroup.enter()
        let faceDetectionLandmarRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            
            if let results = request.results as? [VNFaceObservation] {
                faceLandmarkResults = results
            }
            faceDispatchGroup.leave()
            
        })
        
        //Handle face response after all request finish
        faceDispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let result = faceLandmarkResults.first else {
                return
            }
            
            let confidence = result.confidence
            print("confidence: \(confidence)")
            if confidence > 0.5 {
                self?.handleFaceCaptured(from: sampleBuffer, pixelBuffer: pixelBuffer, result: result)
            }
            
        }
        
        //Begin request
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? imageRequestHandler.perform([faceDetectionLandmarRequest])
        
    }
    
    func handleFaceCaptured(from sampleBuffer: CMSampleBuffer, pixelBuffer: CVImageBuffer, result: VNFaceObservation) {
        
    }
    
}
