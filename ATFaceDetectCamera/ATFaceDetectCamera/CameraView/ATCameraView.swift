//
//  ATCameraView.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 09/08/2023.
//

import Foundation
import UIKit
import AVFoundation
import ATBaseExtensions

extension UIView {
    convenience init(autoLayout: Bool) {
        self.init()
        if autoLayout {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

public protocol ATCameraViewInterface {
    func setDelegate(_ delegate: ATCameraViewDelegate)
    func startCamera()
    func stopCamera()
}

public protocol ATCameraViewDelegate: NSObject {
    func cameraViewOutput(sender: ATCameraViewDelegate, faceImage: UIImage, fullImage: UIImage, boundingBox: CGRect)
}

open class ATCameraView: UIView {
    
    enum FaceState {
        case noFace
        case validFace
    }
    
    //MARK: UI Component
    
    //MARK: Variable
    ///AVFoundation Camera
    internal lazy var avSession: AVCaptureSession? = nil

    internal var videoDataOutput: AVCaptureVideoDataOutput?
    
    internal var previewLayer : AVCaptureVideoPreviewLayer!
    
    let deviceDiscoverySession: AVCaptureDevice.DiscoverySession = {
        
        var camDevice: AVCaptureDevice.DiscoverySession
        let depthCamera = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera], mediaType: .video, position: .front)
        let dualCamera = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .front)
        
        if depthCamera.devices.first != nil {
            
            return depthCamera
            
        } else if dualCamera.devices.first != nil {
            
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
    
    ///Delegate
    weak var delegate: ATCameraViewDelegate? = nil
    
    //MARK: Init
    override public init(frame: CGRect) { //for custom view
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aCoder: NSCoder) { //For xib
        super.init(coder: aCoder)
        commonInit()
    }
    
    //MARK: Setup Func
    private func commonInit() {
        setupLayout()
        setupUI()
    }
    
}

extension ATCameraView {
    
    fileprivate func setupLayout() {
       
    }
    
    fileprivate func setupUI() {
       
    }
    
    private func setupCamera() {
        
        self.avSession = nil
        self.videoDataOutput = nil
        
        //MARK: Flow setup camra: Set AVCaptureInput -> Set AVCapture Output -> Set preview layer
        /// if setting  previewLayer = AVCaptureVideoPreviewLayer(session: avSession) before setup out/input of session, preview layer won't show camera because AVCaptureSesison haven't been setted yet
        self.setupCameraInput()
        self.setupCameraOutput()
        self.setupPreviewLayer()
        
    }
    
}

extension ATCameraView: ATCameraViewInterface {
    
    public func setDelegate(_ delegate: ATCameraViewDelegate) {
        self.delegate = delegate
    }
    
   
    
   
    public func startCamera() {
        
        setupCamera()
        
        DispatchQueue.global(qos: .userInteractive)
            .asyncAfter(deadline: .now() + 0.5) { [weak self] in
                         
            if self?.avSession != nil {
                self?.avSession?.startRunning()
            }
                         
        }
        
    }
    
    public func stopCamera() {
        
    }
    
}


//
////MARK: UIPreviewer
//private struct SwiftUIATCameraView: UIViewRepresentable {
//    func makeUIView(context: Context) -> ATCameraView {
//        return ATCameraView()
//
//    }
//    func updateUIView(_ view: ATCameraView, context: Context) {}
//}
//
//private struct ATCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIATCameraView()
//    }
//}
