//
//  PaintingImageView.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 16.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.

import Foundation
import UIKit

/// Inherits the UIImageView class, but has additional tools for cracking:
/// linkedLists, with previous and next steps, colorization functions
class PaintingImageView: UIImageView {
        
    /// LinkedList which contains all filled activities
    let previousActions = LinkedList<MoveNode>()
    
    /// LinkedList which contains all  undo filled activities
    ///
    /// cleared the next time the user touches it
    var undoActions = LinkedList<MoveNode>()
    
    /// Extracts the user's last action from previousActions, gets the color that was before painting and the coordinate of the touch, paints the place by coordinate, adds this action to undoActions.
    func undo() {
        if let prevStep = previousActions.removeLast(), let point = prevStep.point, let color = prevStep.previosColor, let image = self.image {
            self.image = OpenCVWrapper.floodFill(image, point: point, replacementColor: color)
            self.undoActions.append(prevStep)
        }
    }
    
    /// Extracts the user's last action from undoActions, gets the color that was before painting and the coordinate of the touch, paints the place by coordinate, adds this action to previousActions.
    func redo() {
        if let nextStep = undoActions.removeLast(), let point = nextStep.point, let color = nextStep.nextColor, let image = self.image {
            self.image = OpenCVWrapper.floodFill(image, point: point, replacementColor: color)
            self.previousActions.append(nextStep)
        }
    }
    
    
    
    /// Splits the image into a bitmap, determines the coordinate of pressing relative to a point in the image and the color at that point.
    /// If the color at the point of pressing is not black - fills the area with color, adds this action to previousActions
    ///
    /// - Parameters:
    ///   - touchPoint: coordinate of user clicking on ImageView
    ///   - replacementColor: color in which to paint the area
    func buckerFill(_ touchPoint:CGPoint, replacementColor: UIColor) {
        
        undoActions.removeAll()
        
        guard let image = self.image, let cgImage = image.cgImage, let bitmapContext = createARGBBitmapContext() else {
            debugPrint("image no found or fail to create context")
            return
        }

        let touchPointInImage = convertPointToImage(touchPoint, image: image)
        
        bitmapContext.clear(CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        guard let data = bitmapContext.data?.assumingMemoryBound(to: UInt8.self) else { return }
                
        guard  let targetColorRGBComponent = rgbComponentsAtPoint(touchPointInImage, inData: data, image: image), !targetColorRGBComponent.isBlack() else { return }
        
        let r = CGFloat(targetColorRGBComponent.red) / CGFloat(255.0)
        let g = CGFloat(targetColorRGBComponent.green) / CGFloat(255.0)
        let b = CGFloat(targetColorRGBComponent.blue) / CGFloat(255.0)
        
        self.previousActions.append(MoveNode(point: touchPointInImage,
                                   previosColor: UIColor(red: r, green: g, blue: b, alpha: 1),
                                   nextColor: replacementColor))
        
        self.image = OpenCVWrapper.floodFill(image, point: touchPointInImage, replacementColor: replacementColor)
    }
    
    
    /// Returns the context (a Quartz 2D drawing environment), with image dimensions and color space sRGB
    fileprivate func createARGBBitmapContext() -> CGContext? {
        guard let pixelsWide = self.image?.cgImage?.width, let pixelsHigh = self.image?.cgImage?.height, let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            print("Error allocating color space")
            return nil
        }
        
         let context = CGContext(data: nil, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: pixelsWide * 4 , space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        return context
    }
    
    
    /// Returns the color of the current pixel as an RGBComponent with a value of red, green, and blue
    /// - Parameters:
    ///   - point: the coordinate of the point in the picture where the user clicked
    ///   - data: bitmap from the picture
    ///   - image: current image
    fileprivate func rgbComponentsAtPoint(_ point:CGPoint, inData data: UnsafeMutablePointer<UInt8>, image: UIImage?) -> RGBComponent? {
        guard let width = image?.size.width else {
            print("Error rgbComponentsAtPoint")
            return RGBComponent(red: 0, green: 0, blue: 0)
        }
        let pixelInfo = Int((width * point.y) + point.x) * 4
        return RGBComponent(red: data[pixelInfo+1], green: data[pixelInfo+2], blue: data[pixelInfo+3])
    }
    
    
    /// Сonverts the coordinates of the touch point relative to the imageView, to a point relative to the picture
    /// - Parameters:
    ///   - imageViewPoint: touch point relative to the imageView
    ///   - image: current image
    fileprivate func convertPointToImage(_ imageViewPoint: CGPoint, image: UIImage) -> CGPoint{
        var scale : CGFloat = 1
        if let superView = self.superview as? UIScrollView{
            scale = superView.zoomScale
        }
        let cgImage = image.cgImage!
        let x = Int(CGFloat(cgImage.width) * imageViewPoint.x * scale / self.frame.size.width)
        let y = Int(CGFloat(cgImage.height) * imageViewPoint.y * scale / self.frame.size.height)
        return CGPoint(x: x, y: y)
    }

}

/// An object that contains the three main components of color red, green and blue in the format UInt8
class RGBComponent {
    let red, green, blue: UInt8
    
    init(red: UInt8, green: UInt8, blue: UInt8){
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    
    /// Checks if an object contains all black components
    func isBlack() -> Bool {
        return red == UInt8(0) && green == UInt8(0) && blue == UInt8(0)
    }
}
