//
//  ATCameraView+CameraSetup.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 18/08/2023.
//

import Foundation
import AVFoundation
import UIKit

extension ATNormalCameraView {
    
    internal func setupPreviewLayer() {
        
        guard let avSession = avSession else {
            return
        }
        
        self.layoutIfNeeded()
        previewLayer = AVCaptureVideoPreviewLayer(session: avSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.bounds
        previewLayer.layoutIfNeeded()
        self.layer.insertSublayer(previewLayer, at: 0)
        
    }
    
    internal func setupCameraInput() {
        
        self.avSession = AVCaptureSession()
        
        guard let avSession = avSession else {
            return
        }
        
        avSession.beginConfiguration()
        avSession.automaticallyConfiguresCaptureDeviceForWideColor = true
        avSession.sessionPreset = .high
        
        let defaultVideoDevice: AVCaptureDevice? = deviceDiscoverySession.devices.first
        guard let videoDevice = defaultVideoDevice else {
            fatalError("Cannot find any camera device")
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: videoDevice)
            avSession.addInput(cameraInput)
            avSession.commitConfiguration()
        } catch {
            fatalError("setupCameraInput: \(error.localizedDescription)")
        }
        
    }
    
    
    //MARK: Photo and Video
    internal func setupCameraOutput() {
        
        guard let avSession = avSession else {
            return
        }
        
        avSession.beginConfiguration()
        
        //Video Output
        videoDataOutput = AVCaptureVideoDataOutput()
        guard let videoDataOutput = videoDataOutput else {
            return
        }
        if avSession.canAddOutput(videoDataOutput) {
            
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
            avSession.addOutput(videoDataOutput)
           
            guard let connection = self.videoDataOutput?.connection(with: AVMediaType.video),
                  connection.isVideoOrientationSupported else {
                return
            }
            connection.videoOrientation = .portrait
            
        } else {
            fatalError("Could not add video data output to the session")
        }
        
        avSession.commitConfiguration()
        
    }
    
}
