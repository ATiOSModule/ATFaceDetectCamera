//
//  UIView+Layer.swift
//  ATBaseExtensions
//
//  Created by Wee on 08/08/2023.
//
//  Description: UIView extension for custom layer like: corner, border,...

import Foundation
import UIKit

//MARK: Corner Radius
public extension UIView {
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> UIView {
        layer.cornerRadius = radius
        return self
    }
    
}

//MARK: Border
public extension UIView {
    
    enum BorderSide {
        case left
        case right
        case top
        case bottom
    }
    
    @discardableResult
    func addBorder(with color: UIColor =  UIColor.clear,
                   width: CGFloat = 0.3,
                   radius: CGFloat,
                   backgroundColor: UIColor) -> UIView {
        
        self.layer.borderWidth = width
        self.layer.cornerRadius =  radius
        self.layer.borderColor = color.cgColor
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
        return self
        
    }
    
    @discardableResult
    func addBorder(toSide side: BorderSide,
                   withColor color: CGColor,
                   withThickness thickness: CGFloat) -> UIView {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
            
        case .left:
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
            break
            
        case .right:
            border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
            break
            
        case .top:
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
            break
            
        case .bottom:
            border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
            break
        }
        
        layer.addSublayer(border)
        return self
        
    }
    
}

//MARK: Shadow
public extension UIView {
    
    @discardableResult
    func dropShadow(color: UIColor,
                    opacity: Float = 0.5,
                    offSet: CGSize,
                    radius: CGFloat = 1,
                    scale: Bool = true) -> UIView {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    
        return self
        
    }
    
}
