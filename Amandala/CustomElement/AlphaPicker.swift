//
//  SaturationPicker.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 21.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit

public protocol AlphaPickerDelegate : class {
    /// reports that the alpha value has been changed and conveys a new color
    func valuePicked(_ color: UIColor)
}

/// Vertical alpha picker, to select a new color, which is a copy of the current, but with a different alpha value
open class AlphaPicker: UIView {
    
        
    open weak var delegate: AlphaPickerDelegate?
    
    /// when choosing a color, it splits it into components and selects the current values ​​of red green and blue
    open var currentColor: UIColor {
        get {
            return color
        }
        set(newCurrentColor) {
            color = newCurrentColor
            
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            if color.getRed(&r, green: &g, blue: &b, alpha: nil) {
                
                redValue = r
                greenValue = g
                blueValue = b
                
                update()
                setNeedsDisplay()
            }
        }
    }
    
    
    open var cornerRadius: CGFloat = 10.0
    
    //MARK: temp var
    fileprivate var color: UIColor = UIColor.clear
    fileprivate var currentSelectionY: CGFloat = 0.0
    fileprivate var alphaGradientImage: UIImage?
    
    // MARK: color component values
    fileprivate var redValue: CGFloat = 1
    fileprivate var greenValue: CGFloat = 1
    fileprivate var blueValue: CGFloat = 1
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        update()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    /// Builds an image with a vertical gradient from alpha values ​​0 to 1
    func generateAlphaGradientImage(_ size: CGSize) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        UIBezierPath(roundedRect: rect, cornerRadius: 0).addClip()
        
        for y: Int in 0 ..< Int(size.height) {
            UIColor(red: redValue , green: greenValue, blue: blueValue, alpha: 1 - CGFloat(CGFloat(y) / size.height)).set()
            let temp = CGRect(x: 0, y: CGFloat(y), width: size.width, height: 1)
            UIRectFill(temp)
        }
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// updates AlphaPicker
    func update() {
        currentSelectionY = self.frame.size.width / 2 + 2
        alphaGradientImage = generateAlphaGradientImage(self.frame.size)
    }
    
    /// draws a line that shows what alpha value the user selected
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = self.frame.size.width
        let halfRadius = radius * 0.5
        var circleY = currentSelectionY
        if circleY < 0 {
            circleY = 0
        }
        let circleRect = CGRect(x: 0, y: circleY, width: radius + 2, height: 2)
        var hueRect = rect
        
        hueRect.size.height -= radius
        hueRect.origin.y += halfRadius
        alphaGradientImage?.draw(in: hueRect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(circleRect)
        context?.fillPath()
        context?.strokePath()
        
    }
    
    // MARK: - Touch events
    
    ///     Handles the touchesBegan event:
    ///    launches touch processing function (handleTouch)
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    ///     Handles the touchesMoved event:
    ///     launches touch processing function (handleTouch)
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    
    ///     Handles the touchesEnded event:
    ///     launches touch processing function (handleTouch)
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    // MARK: - Touch handling
    
    
    ///    Handles the handleTouch event:
    ///        based on the touch coordinate, calculates the alpha channel values, and delegates the corresponding color value.
    ///
    ///  - parameter touchPoint touch point coordinate
    func handleTouch(_ touchPoint: CGPoint) {
        currentSelectionY = touchPoint.y
        
        let offset = self.frame.size.width
        let halfOffset = offset * 0.5
        
        if currentSelectionY < halfOffset {
            currentSelectionY = halfOffset
        }
            
        else if currentSelectionY >= self.frame.size.height - halfOffset {
            currentSelectionY = self.frame.size.height - halfOffset
        }
        
        let alpha = 1 - CGFloat((currentSelectionY - halfOffset) / (self.frame.size.height - offset))
        
        color = convertColorFromRGBAToRGB(alphaValue: alpha)
        
        delegate?.valuePicked(color)
        
        setNeedsDisplay()
    }
    
    
    
    ///     Computes the RGB color matching the current color with the changed alpha value.
    ///
    ///     - parameter alphaValue new alpha value
    ///     - Returns: new color in RGB format, which is similar to the current color in RGBA with changed alpha
    
    func convertColorFromRGBAToRGB(alphaValue: CGFloat) -> UIColor {
        
        return UIColor(red: (redValue + (1 - redValue ) * (1 - alphaValue)),
                       green: (greenValue + (1 - greenValue ) * (1 - alphaValue)),
                       blue: (blueValue + (1 - blueValue ) * (1 - alphaValue)),
                       alpha: 1)
    }
}
