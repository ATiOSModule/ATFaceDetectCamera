//
//  ATCameraViewInterface.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import Foundation
import UIKit

public protocol ATCameraViewInterface: UIView {
    
    func setDelegate(_ delegate: ATCameraDelegate) throws
    func setupCamera()
    func startCamera()
    func stopCamera()
    
}
