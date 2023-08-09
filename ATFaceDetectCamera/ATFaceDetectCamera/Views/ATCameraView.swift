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
import SwiftUI

extension UIView {
    convenience init(autoLayout: Bool) {
        self.init()
        if autoLayout {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

open class ATCameraView: UIView {
    
    enum FaceState {
        case noFace
        case validFace
    }
    
    //MARK: UI Component
    fileprivate let logoImgView: UIImageView = UIImageView(autoLayout: true)
    fileprivate let backBtnView: UIButton = UIButton(autoLayout: true)
    
    
    //MARK: Variable
    
    
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
        
        self.addSubview(logoImgView)
        self.addSubview(backBtnView)
        
        //logoImgView
        logoImgView
        .addTopConstraint(to: self,padding: 20)
        .addCenterXConstraint(to: self)
        
        //backBtnView
        backBtnView
        .addLeadingConstraint(to: self, padding: 10)
        .addCenterYConstraint(to: logoImgView)
        
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .blue
    }
    
}

//MARK: UIPreviewer
private struct SwiftUIATCameraView: UIViewRepresentable {
    func makeUIView(context: Context) -> ATCameraView {
        return ATCameraView()

    }
    func updateUIView(_ view: ATCameraView, context: Context) {}
}

private struct ATCameraView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIATCameraView()
    }
}
