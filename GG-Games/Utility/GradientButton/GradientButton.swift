//
//  GradientButton.swift
//  AlertVCExample
//
//  Created by Rumana Rahman on 8/8/18.
//  Copyright © 2018 Rumana Rahman. All rights reserved.
//

import UIKit
@IBDesignable
class GradientButton: UIButton {

    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
           
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
            
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        self.layer.cornerRadius = 5
    
    }
    
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.7)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.locations = [0.0, 1.0]
    
            layer.insertSublayer(gradientLayer, at: 0)
            
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
