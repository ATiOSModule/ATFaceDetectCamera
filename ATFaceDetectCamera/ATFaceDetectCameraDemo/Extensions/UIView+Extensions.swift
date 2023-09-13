//
//  UIView+Extensions.swift
//  ATFaceDetectCameraDemo
//
//  Created by Anh Tuấn Nguyễn on 13/09/2023.
//

import UIKit

extension UIView {
    
    convenience init(autoLayout: Bool) {
        self.init()
        if autoLayout {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
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
