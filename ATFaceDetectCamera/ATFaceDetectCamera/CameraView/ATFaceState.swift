//
//  ATFaceState.swift
//  ATFaceDetectCamera
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import Foundation

public enum ATFaceState {
    case validFace
    case noFace
    case faceTooLeaningLeft
    case faceTooLeaningRight
    case faceTooAlignUp
    case faceTooAlignDown
    case faceTooSmall
    case faceTooBig
    case faceIsNotCenter
}
