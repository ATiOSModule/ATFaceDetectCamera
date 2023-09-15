//
//  ATTrueDepthCameraView+FaceDetect.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 14/09/2023.
//

import Foundation
import UIKit
import AVFoundation
import Vision

extension ATTrueDepthCameraView: AVCaptureDataOutputSynchronizerDelegate {
    
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        
        guard let videoDataOutput = videoDataOutput,
              let depthDataOutput = depthDataOutput else {
            return
        }
        
        guard let syncedDepthData: AVCaptureSynchronizedDepthData =
            synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
              let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
            synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else {
                return
        }
        
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped {
            return
        }
        
        let depthData = syncedDepthData.depthData
        let sampleBuffer = syncedVideoData.sampleBuffer
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
        }
        
        self.detectFace(from: sampleBuffer, pixelBuffer: imageBuffer, depthData: depthData)
        
    }
    
}

extension ATTrueDepthCameraView {
    
    fileprivate func detectFace(from sampleBuffer: CMSampleBuffer,
                                pixelBuffer: CVPixelBuffer,
                                depthData: AVDepthData) {
        
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
        
        faceDispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let result = faceRectResults.first else {
                return
            }
            
            let confidence = result.confidence
            if confidence > 0.5 {
                self?.handleValidFace(from: sampleBuffer,
                                      pixelBuffer: pixelBuffer,
                                      depthData: depthData,
                                      result: result)
            }
            
        }
        
        //Begin request
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? imageRequestHandler.perform([faceDetectRectangleRequest])
        
        
    }
    
    fileprivate func handleValidFace(from sampleBuffer: CMSampleBuffer,
                                     pixelBuffer: CVPixelBuffer,
                                     depthData: AVDepthData,
                                     result: VNFaceObservation) {
        
        let faceValidationResult = faceValidator.fullyCheckFaceValidation(result: result)
        if faceValidationResult.isValid == false {
            self.delegate?.cameraViewOutput(sender: self, invalidFace: result, depthData: depthData, invalidType: faceValidationResult.faceState)
            return
        }
        
        self.captureFace(from: sampleBuffer,
                         pixelBuffer: pixelBuffer,
                         depthData: depthData,
                         result: result)
        
    }
    
    fileprivate func captureFace(from sampleBuffer: CMSampleBuffer,
                                 pixelBuffer: CVPixelBuffer,
                                 depthData: AVDepthData,
                                 result: VNFaceObservation) {
        
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
        
        let capturedFaceResult: ATTrueDepthResult = ATTrueDepthResult(faceObservation: result,
                                                                      depthData: depthData,
                                                                      faceImage: faceImage,
                                                                      fullImage: flipFullImage,
                                                                      boundingBox: result.boundingBox)
        
        self.delegate?.cameraViewOutput(sender: self, result: capturedFaceResult)
        
    }
    
}
