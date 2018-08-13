//
//  GradientView.swift
//  GG-Games
//
//  Created by Morshed Alam on 4/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit

//@IBDesignable
class GradientView: UIView {
    
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        let colors = [
            self.leftColor.cgColor,
            self.rightColor.cgColor,
            ]
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.1)
        
        
        return gradientLayer
    }()
    
    
    // @IBInspectable
    var leftColor: UIColor = UIColor.colorFrom(hexString: "#706CE2")! {
        didSet {
            setNeedsDisplay()
            
            
        }
    }
    
    // @IBInspectable
    var rightColor: UIColor = UIColor.colorFrom(hexString: "#3FADFD")! {
        didSet {
            setNeedsDisplay()
            
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // layer.borderColor = UIColor.clear.cgColor
        gradientLayer.frame = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width,
            height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}


extension UINavigationBar
{
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
