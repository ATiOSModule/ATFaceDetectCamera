//
//  ATTrueDepthCameraView+CameraSetup.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 14/09/2023.
//

import Foundation
import AVFoundation
import UIKit

extension ATTrueDepthCameraView {
    
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
        
        //Begin config AVCaptureSession
        avSession.beginConfiguration()
        
        //Video Output
        videoDataOutput = AVCaptureVideoDataOutput()
        guard let videoDataOutput = videoDataOutput else {
            return
        }
       
        self.setupCameraVideoOutput(videoDataOutput: videoDataOutput,
                                    avSession: avSession)
        
        //Depth Output
        depthDataOutput = AVCaptureDepthDataOutput()
        guard let depthDataOutput = depthDataOutput else {
            return
        }
        
        self.setupCameraDepthOutput(depthDataOutput: depthDataOutput,
                                    avSession: avSession)
        
        //Commit session
        avSession.commitConfiguration()
        
        //Output synchronizer setup
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
        guard let outputSynchronizer = outputSynchronizer else {
            return
        }
      
        outputSynchronizer.setDelegate(self, queue: synchronizerOutputQueue)
        
    }
    
}

extension ATTrueDepthCameraView {
    
    fileprivate func setupCameraVideoOutput(videoDataOutput: AVCaptureVideoDataOutput,
                                            avSession: AVCaptureSession) {
        
        
        if avSession.canAddOutput(videoDataOutput) {
            
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            avSession.addOutput(videoDataOutput)
           
            guard let connection = self.videoDataOutput?.connection(with: AVMediaType.video),
                  connection.isVideoOrientationSupported else {
                return
            }
            connection.videoOrientation = .portrait
            
        } else {
            fatalError("Could not add video data output to the session")
        }
        
    }
    
    fileprivate func setupCameraDepthOutput(depthDataOutput: AVCaptureDepthDataOutput,
                                            avSession: AVCaptureSession) {
        
        if avSession.canAddOutput(depthDataOutput) {
            
            depthDataOutput.isFilteringEnabled = false
            depthDataOutput.alwaysDiscardsLateDepthData = true
            avSession.addOutput(depthDataOutput)
            
            guard let connection = self.depthDataOutput?.connection(with: AVMediaType.depthData),
                  connection.isVideoOrientationSupported else {
                return
            }
            connection.isEnabled = true
            connection.videoOrientation = .portrait
            
            //Config best depth data
            let defaultVideoDevice: AVCaptureDevice? = deviceDiscoverySession.devices.first
            guard let videoDevice = defaultVideoDevice else {
                fatalError("Cannot find any camera device")
            }
            
            let depthFormats = videoDevice.activeFormat.supportedDepthDataFormats
            let filtered = depthFormats.filter({
                CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
            })
            
            let selectedFormat = filtered.max(by: {
                first, second in CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
            })
            
            do {
                try videoDevice.lockForConfiguration()
                videoDevice.activeDepthDataFormat = selectedFormat
                videoDevice.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
                avSession.commitConfiguration()
                return
            }
            
        } else {
            fatalError("Could not add depth data output to the session")
        }
        
    }
    
}
