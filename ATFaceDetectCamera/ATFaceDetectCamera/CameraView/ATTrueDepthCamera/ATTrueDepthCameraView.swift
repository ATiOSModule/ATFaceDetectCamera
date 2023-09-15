//
//  ATTrueDepthCameraView.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 14/09/2023.
//

import Foundation
import UIKit
import AVFoundation
import Vision

internal final class ATTrueDepthCameraView: UIView  {
    
    //MARK: UI Component
    
    //MARK: Variable
    ///AVFoundation Camera
    internal lazy var avSession: AVCaptureSession? = nil

   
    internal var videoDataOutput: AVCaptureVideoDataOutput?
    internal var depthDataOutput: AVCaptureDepthDataOutput?
    internal var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    
    internal var previewLayer : AVCaptureVideoPreviewLayer!
    
    let deviceDiscoverySession: AVCaptureDevice.DiscoverySession = {
        
        var camDevice: AVCaptureDevice.DiscoverySession
        let trueDepthCam = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera], mediaType: .video, position: .front)
        
        if trueDepthCam.devices.first != nil {
            
            return trueDepthCam
            
        } else {
            
            return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
            
        }
       
    }()
    
    ///Queue
    internal let synchronizerOutputQueue = DispatchQueue(label: "synchronizerOutputQueue",
                                                         qos: .userInitiated,
                                                         attributes: [],
                                                         autoreleaseFrequency: .workItem)
    
    /// Validator
    internal lazy var faceValidator: ATFaceValidator = ATFaceValidator()
    
    ///Delegate
    fileprivate (set) weak var delegate: ATTrueDepthCameraDelegate? = nil
    internal var startCaptureFace = false
    
}

extension ATTrueDepthCameraView: ATCameraViewInterface {
    
    func setDelegate(_ delegate: ATCameraDelegate) throws {
        
        guard let delegate = delegate as? ATTrueDepthCameraDelegate else {
            throw ATDelegateError.notConformToATTrueDepthCameraDelegate
        }
        
        self.delegate = delegate
        
    }
    
    func setupCamera() {
        
        self.avSession = nil
        self.depthDataOutput = nil
        self.videoDataOutput = nil
        self.outputSynchronizer = nil
        
        //MARK: Flow setup camra: Set AVCaptureInput -> Set AVCapture Output -> Set preview layer
        /// if setting  previewLayer = AVCaptureVideoPreviewLayer(session: avSession) before setup out/input of session, preview layer won't show camera because AVCaptureSesison haven't been setted yet
        self.setupCameraInput()
        self.setupCameraOutput()
        self.setupPreviewLayer()
    }
    
    func startCamera() {
        
        setupCamera()
        startCaptureFace = false
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                         
            if self?.avSession != nil {
                self?.avSession?.startRunning()
            }
                         
        }
        
        DispatchQueue.global(qos: .userInteractive)
            .asyncAfter(deadline: .now() + 1) {  [weak self] in
                
            self?.startCaptureFace = true
                
        }
        
    }
    
    func stopCamera() {
        if self.avSession != nil {
            self.avSession?.stopRunning()
        }
    }
    
}
