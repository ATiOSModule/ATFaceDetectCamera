/*
//  UIView+ExAutoLayout.swift
//  ATBaseExtensions
//
//  Created by Wee on 08/08/2023.
//
//  Description: UIView extension for autolayout
//
//  Related:
//  - https://www.avanderlee.com/swift/auto-layout-programmatically/ really cool wrapper
 
*/


import UIKit

/** Wrapper for uiview that using autolayout, getting rid of long shit translatesAutoresizingMaskIntoConstraints thing
 
 - Example:
 @UsesAutoLayout
 var label = UILabel()
*/
@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

//MARK: Faster way to add constraint
public extension UIView {
    
    enum LayoutType {
        case equal
        case greaterThanOrEqual
        case lessThanOrEqual
    }
    
    //MARK: Wrapper Function
    
    /** Function to add constraint relationshop between 2 Y anchors
     
    Wrapped function for adding Y anchor constraint relationship,
    Y anchor: Top,Bottom, CenterY, lastBaseline, firstBaseline
     
    - Parameter baseAnchor: uiview y anchor itsself
    - Parameter anchor: the uiview related y anchor
    - Parameter padding: the constraint constant, padding between 2 constraint
    - Parameter priority: the layout priority
    - Parameter type: equal, greaterThan or lessThan
     
    - Returns: UIView after layout
    */
    
    private func addYAnchorConstraint(from baseAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                                      to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                                      padding: CGFloat,
                                      priority: Float,
                                      type: LayoutType) -> UIView {
        
        var constraint = NSLayoutConstraint()
        switch type {
            
        case .equal:
            constraint = baseAnchor.constraint(equalTo: anchor, constant: padding)
            
        case .greaterThanOrEqual:
            constraint = baseAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
            
        case .lessThanOrEqual:
            constraint = baseAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
            
        }
        
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
        
    }
    
    /** Function to add constraint relationshop between 2 Y anchors
     
    Wrapped function for adding X anchor constraint relationship,
    Y anchor: Leading,Trailing, CenterX,
     
    - Parameter baseAnchor: uiview x anchor itsself
    - Parameter anchor: the uiview related x anchor
    - Parameter padding: the constraint constant, padding between 2 constraint
    - Parameter priority: the layout priority
    - Parameter type: equal, greaterThan or lessThan
     
    - Returns: UIView after layout
    */
    
    private func addXAnchorConstraint(from baseAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                                      to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                                      padding: CGFloat,
                                      priority: Float,
                                      type: LayoutType) -> UIView {
        
        var constraint = NSLayoutConstraint()
        switch type {
            
        case .equal:
            constraint = baseAnchor.constraint(equalTo: anchor, constant: padding)
            
        case .greaterThanOrEqual:
            constraint = baseAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
            
        case .lessThanOrEqual:
            constraint = baseAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
            
        }
        
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
        
    }
    
    /** Function to add constraint relationshop between 2 Dimension anchors
     
    Wrapped function for adding X anchor constraint relationship,
    Y anchor: Width,Height
     
    - Parameter baseAnchor: uiview dimension anchor itsself
    - Parameter anchor: the uiview related dimension anchor
    - Parameter padding: the constraint constant, padding between 2 constraint
    - Parameter priority: the layout priority
    - Parameter type: equal, greaterThan or lessThan
     
    - Returns: UIView after layout
    */
    
    private func addDimensionAnchorConstraint(from baseAnchor: NSLayoutDimension,
                                              to anchor: NSLayoutDimension,
                                              padding: CGFloat,
                                              multiplier: CGFloat,
                                              priority: Float,
                                              type: LayoutType) -> UIView {
        
        var constraint = NSLayoutConstraint()
        switch type {
            
        case .equal:
            constraint = baseAnchor.constraint(equalTo: anchor,multiplier: multiplier, constant: padding)
            
        case .greaterThanOrEqual:
            constraint = baseAnchor.constraint(greaterThanOrEqualTo: anchor,multiplier: multiplier, constant: padding)
            
        case .lessThanOrEqual:
            constraint = baseAnchor.constraint(lessThanOrEqualTo: anchor,multiplier: multiplier, constant: padding)
            
        }
       
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
        
    }
    
    //MARK: Dimension Anchor Constraint
    @discardableResult
    func addWidthConstraint(type: LayoutType = .equal,
                            to view: UIView,
                            padding: CGFloat = 0,
                            multiplier: CGFloat,
                            priority: Float = 1000) -> UIView {
      
      return self.addDimensionAnchorConstraint(from: self.widthAnchor,
                                               to: view.widthAnchor,
                                               padding: padding,
                                               multiplier: multiplier,
                                               priority: priority,
                                               type: type)
      
    }
    
    @discardableResult
    func addHeightConstraint(type: LayoutType = .equal,
                             to view: UIView,
                             padding: CGFloat = 0,
                             multiplier: CGFloat,
                             priority: Float = 1000) -> UIView {
        
      return self.addDimensionAnchorConstraint(from: self.heightAnchor,
                                               to: view.heightAnchor,
                                               padding: padding,
                                               multiplier: multiplier,
                                               priority: priority,
                                               type: type)
      
    }
    
    //MARK: X Anchor Constraint
    @discardableResult
    func addLeadingConstraint(type: LayoutType = .equal,
                              to view: UIView,
                              padding: CGFloat = 0,
                              priority: Float = 1000) -> UIView {
        
        return self.addXAnchorConstraint(from: self.leadingAnchor,
                                         to: view.leadingAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addTrailingConstraint(type: LayoutType = .equal,
                               to view: UIView,
                               padding: CGFloat = 0,
                               priority: Float = 1000) -> UIView {
        
        return self.addXAnchorConstraint(from: self.trailingAnchor,
                                         to: view.trailingAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addCenterXConstraint(type: LayoutType = .equal,
                              to view: UIView,
                              padding: CGFloat = 0,
                              priority: Float = 1000) -> UIView {
        
        return self.addXAnchorConstraint(from: self.centerXAnchor,
                                         to: view.centerXAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
  
    //MARK: Y Anchor Constraint
    @discardableResult
    func addTopConstraint(type: LayoutType = .equal,
                          to view: UIView,
                          padding: CGFloat = 0,
                          priority: Float = 1000) -> UIView {
        
        return self.addYAnchorConstraint(from: self.topAnchor,
                                         to: view.topAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addBottomConstraint(type: LayoutType = .equal,
                             to view: UIView,
                             padding: CGFloat = 0,
                             priority: Float = 1000) -> UIView {
        
        return self.addYAnchorConstraint(from: self.bottomAnchor,
                                         to: view.bottomAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addCenterYConstraint(type: LayoutType = .equal,
                              to view: UIView,
                              padding: CGFloat = 0,
                              priority: Float = 1000) -> UIView {
        
        return self.addYAnchorConstraint(from: self.centerYAnchor,
                                         to: view.centerYAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addFirstBaseLineConstraint(type: LayoutType = .equal,
                                    to view: UIView,
                                    padding: CGFloat = 0,
                                    priority: Float = 1000) -> UIView {
        
        return self.addYAnchorConstraint(from: self.firstBaselineAnchor,
                                         to: view.firstBaselineAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
    @discardableResult
    func addLastBaseLineConstraint(type: LayoutType = .equal,
                                   to view: UIView,
                                   padding: CGFloat = 0,
                                   priority: Float = 1000) -> UIView {
        
        return self.addYAnchorConstraint(from: self.lastBaselineAnchor,
                                         to: view.lastBaselineAnchor,
                                         padding: padding,
                                         priority: priority,
                                         type: type)
        
    }
    
}

//MARK: Faster layout extension for common case
public extension UIView {
    
    /** center a view in it's container
     
    Use this fucntion to center a view in it's container, with width and height
     
    - Parameter container (UIView): View that contain this view
    - Parameter xPadding (CGFloat): padding between centerX constraints
    - Parameter yPadding (CGFloat): padding between centerY constraints
    - Parameter width (CGFloat): width value of view's width constraint
    - Parameter height (CGFloat): height value of view's height constraint
    */
    
    func centerIn(container: UIView,
                  xPadding: CGFloat = 0,
                  yPadding: CGFloat = 0,
                  width: CGFloat? = nil,
                  height: CGFloat? = nil) {
      
        centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: xPadding).isActive = true
        centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: yPadding).isActive = true
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            
        }
    }
    
    /** Add full constraint to container view
     
    Use this fucntion to fix top,bot,leading,trailing constraint to container view
    - Parameter container (UIView): View that contain this view
    */
    func fixInView(_ container: UIView){
        
        self.frame = container.frame
        container.addSubview(self)
    
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
    }
    
}
