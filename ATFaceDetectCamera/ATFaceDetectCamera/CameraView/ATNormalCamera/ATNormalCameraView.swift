//
//  ATCameraView.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 09/08/2023.
//

import Foundation
import UIKit
import AVFoundation
import Vision

internal final class ATNormalCameraView: UIView  {
    
    //MARK: UI Component
    
    //MARK: Variable
    ///AVFoundation Camera
    internal lazy var avSession: AVCaptureSession? = nil

    internal var videoDataOutput: AVCaptureVideoDataOutput?
    internal var previewLayer : AVCaptureVideoPreviewLayer!
    
    let deviceDiscoverySession: AVCaptureDevice.DiscoverySession = {
        
        var camDevice: AVCaptureDevice.DiscoverySession
        let dualCamera = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .front)
        
        if dualCamera.devices.first != nil {
            
            return dualCamera
            
        } else {
            
            return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
            
        }
       
    }()
    
    ///Queue
    internal let videoOutputQueue = DispatchQueue(label: "videoDataQueue",
                                                  qos: .userInitiated,
                                                  attributes: [],
                                                  autoreleaseFrequency: .workItem)
    
    /// Validator
    internal lazy var faceValidator: ATFaceValidator = ATFaceValidator()
    
    ///Delegate
    fileprivate (set) weak var delegate: ATNormalCameraDelegate? = nil
    internal var startCaptureFace = false
    
}

extension ATNormalCameraView: ATCameraViewInterface {
    
    func setDelegate(_ delegate: ATCameraDelegate) throws {
        
        guard let delegate = delegate as? ATNormalCameraDelegate else {
            throw ATDelegateError.notConformToATNormalCameraDelegate
        }
        
        self.delegate = delegate
    }
    
   
    public func setupCamera() {
        
        self.avSession = nil
        self.videoDataOutput = nil
        
        //MARK: Flow setup camra: Set AVCaptureInput -> Set AVCapture Output -> Set preview layer
        /// if setting  previewLayer = AVCaptureVideoPreviewLayer(session: avSession) before setup out/input of session, preview layer won't show camera because AVCaptureSesison haven't been setted yet
        self.setupCameraInput()
        self.setupCameraOutput()
        self.setupPreviewLayer()
        
    }
   
    public func startCamera() {
        
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
    
    public func stopCamera() {
        if self.avSession != nil {
            self.avSession?.stopRunning()
        }
    }
    
}
