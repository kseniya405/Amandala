//
//  SaturationPicker.swift
//  Amandala
//
//  Created by Денис Марков on 21.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit

public protocol SaturationPickerDelegate : class {
    func valuePicked(_ color: UIColor)
}

open class SaturationPicker: UIView {
        
    // MARK: - Constants
    
    let PercentMaxValue: CGFloat = 100
    
    // MARK: - Main public properties
    
    open weak var delegate: SaturationPickerDelegate?
    open var currentColor: UIColor {
        get {
            return color
        }
        set(newCurrentColor) {
            color = newCurrentColor

            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
                
                redValue = r
                greenValue = g
                blueValue = b
                alphaValue = a
                                
                update()
                setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Additional public properties
    
    open var cornerRadius: CGFloat = 10.0
    
    // MARK: - Private properties
    
    fileprivate var color: UIColor = UIColor.clear
    fileprivate var currentSelectionY: CGFloat = 0.0
    fileprivate var hueImage: UIImage?
    fileprivate var alphaValue: CGFloat = 1
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
    
    // MARK: - Prerendering
    
    func generateHUEImage(_ size: CGSize) -> UIImage? {
        
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
    
    // MARK: - Updating
    
    func update() {
        currentSelectionY = self.frame.size.width / 2 + 2
        hueImage = generateHUEImage(self.frame.size)
    }
    
    // MARK: - Drawing
    
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
        hueImage?.draw(in: hueRect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(circleRect)
        context?.fillPath()
        context?.strokePath()
        
    }
    
    // MARK: - Touch events
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // MARK: - Touch handling
    
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

        alphaValue = 1 - CGFloat((currentSelectionY - halfOffset) / (self.frame.size.height - offset))
        
        color = UIColor(red: (redValue + (1 - redValue ) * (1 - alphaValue)),
                        green: (greenValue + (1 - greenValue ) * (1 - alphaValue)),
                        blue: (blueValue + (1 - blueValue ) * (1 - alphaValue)),
                        alpha: 1)

        delegate?.valuePicked(color)

        setNeedsDisplay()
    }
    
}
