//
//  CGImage+Extensions.swift
//  ATFaceDetectCamera
//
//  Created by Wee on 22/08/2023.
//

import UIKit
import Vision

extension CGImage {
    
    func resizeImage(width: Float, height: Float) -> CGImage? {
        
        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: self.bitsPerComponent,
                                      bytesPerRow: self.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: self.alphaInfo.rawValue) else {
            return nil
        }
        
        // draw image to context (resizing it)
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        
        // extract resulting image from context
        return context.makeImage()
        
    }
    
    func cropImage(objectObservation: VNDetectedObjectObservation) -> CGImage? {
        
        let imgWidth = CGFloat(self.width)
        let imgHeight = CGFloat(self.height)
        
        let boundingBox =  objectObservation.boundingBox
      
        let width = boundingBox.width * imgWidth
        let height = boundingBox.height * imgHeight
        let x = boundingBox.origin.x * imgWidth
        let y = ((1 - boundingBox.origin.y) * imgHeight) - height
       
        let croppingRect = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: height)
        
        let image = self.cropping(to: croppingRect)
        return image
        
    }
    
    func rotating(to orientation: CGImagePropertyOrientation) -> CGImage? {
        var orientedImage: CGImage?
        
        let originalWidth = self.width
        let originalHeight = self.height
        let bitsPerComponent = self.bitsPerComponent
        let bitmapInfo = self.bitmapInfo
        
        guard let colorSpace = self.colorSpace else {
            return nil
        }
        
        var degreesToRotate: Double
        var swapWidthHeight: Bool
        var mirrored: Bool
        
        switch orientation {
        case .up:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = false
            break
        case .upMirrored:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = true
            break
        case .right:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = false
            break
        case .rightMirrored:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = true
            break
        case .down:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = false
            break
        case .downMirrored:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = true
            break
        case .left:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = false
            break
        case .leftMirrored:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = true
            break
        }
        
        let radians = degreesToRotate * Double.pi / 180.0
        
        var width: Int
        var height: Int
        
        if swapWidthHeight {
            width = originalHeight
            height = originalWidth
        } else {
            width = originalWidth
            height = originalHeight
        }
        
        let bytesPerRow = (width * bitsPerPixel) / 8
        
        let contextRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        contextRef?.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
        
        if mirrored {
            contextRef?.scaleBy(x: -1.0, y: 1.0)
        }
        
        contextRef?.rotate(by: CGFloat(radians))
        
        if swapWidthHeight {
            contextRef?.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
        } else {
            contextRef?.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
        }
        
        contextRef?.draw(self, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(originalWidth), height: CGFloat(originalHeight)))
        
        orientedImage = contextRef?.makeImage()
        
        return orientedImage
    }
    
}
