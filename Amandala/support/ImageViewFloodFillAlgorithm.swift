//
//  ImageViewFloodFillAlgorithm.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit

extension PaintingImageView {
    
    
    func buckerFill(_ touchPoint:CGPoint, replacementColor: UIColor) {
        
        guard let image = self.imageNotCompression, let cgImage = image.cgImage else {
            print("image no found")
            return
        }
        guard let bitmapContext = createARGBBitmapContext() else{
            print("fail to create context")
            return
        }
        var touchPointInImage = convertPointToImage(touchPoint, image: image)
        
        bitmapContext.clear(CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        guard let data = bitmapContext.data?.assumingMemoryBound(to: UInt8.self) else { return }
        var targetColorRGBComponent  = rgbComponentsAtPoint(touchPointInImage, inData: data, image: image)
        if targetColorRGBComponent.equalToComponent(RGBComponent(red: 0, green: 0, blue: 0)) && self.getBorder().count > 0 {
            touchPointInImage = searchSpacePixel(touchPointInImage: touchPointInImage, image: image)
            targetColorRGBComponent  = rgbComponentsAtPoint(touchPointInImage, inData: data, image: image)
            print("touchPointInImage ", touchPointInImage, "targetColorRGBComponent ", targetColorRGBComponent.red , targetColorRGBComponent.green, targetColorRGBComponent.blue)
        }
        guard !targetColorRGBComponent.equalToComponent(RGBComponent(red: UInt8(0), green: UInt8(0), blue: UInt8(0))) &&
        !targetColorRGBComponent.equalToComponent(RGBComponent(red: UInt8(180), green: UInt8(180), blue: UInt8(180))) else { return }
        self.imageNotCompression = OpenCVWrapper.floodFill(image, point: touchPointInImage, replacementColor: replacementColor)
        self.image = OpenCVWrapper.medianBlur(imageNotCompression)
    }
    
    
    fileprivate func createARGBBitmapContext() -> CGContext?{
        guard let pixelsWide = self.image?.cgImage?.width, let pixelsHigh = self.image?.cgImage?.height, let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear) else {
            print("Error allocating color space")
            return nil
        }
        
        let bitmapData = malloc(pixelsWide * 4 * pixelsHigh)
        
        guard let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: pixelsWide * 4 , space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            print("Context not create")
            return nil
        }
        return context
    }
    
    fileprivate func rgbComponentsAtPoint(_ point:CGPoint, inData data: UnsafeMutablePointer<UInt8>, image: UIImage?) -> RGBComponent {
        guard let width = image?.size.width else {
            print("Error rgbComponentsAtPoint")
            return RGBComponent(red: 0, green: 0, blue: 0)
        }
        let pixelInfo = Int((width * point.y) + point.x) * 4
        return RGBComponent(red: data[pixelInfo+1], green: data[pixelInfo+2], blue: data[pixelInfo+3])
    }
    
    fileprivate func convertPointToImage(_ imageViewPoint: CGPoint, image: UIImage)->CGPoint{
        var scale : CGFloat = 1
        if let superView = self.superview as? UIScrollView{
            scale = superView.zoomScale
        }
        let cgImage = image.cgImage!
        let x = Int(CGFloat(cgImage.width) * imageViewPoint.x * scale / self.frame.size.width)
        let y = Int(CGFloat(cgImage.height) * imageViewPoint.y * scale / self.frame.size.height)
        return CGPoint(x: x, y: y)
    }
    
    fileprivate func searchSpacePixel( touchPointInImage: CGPoint, image: UIImage) -> CGPoint {
        
        let width = Int(image.cgImage!.width)
        let height = Int(image.cgImage!.height)
        let point = LinkedList<PointNode>()
        let x = Int(touchPointInImage.x)
        let y = Int(touchPointInImage.y)
        let startIndex = Int((width * y) + x)
        let boolData = getBorder()
        point.removeAll()
        point.append(PointNode(pointX: x, pointY: y, index: startIndex))
        
        while let currentPoint = point.removeFirst(){
            
            if let currentX = currentPoint.pointX, let currentY = currentPoint.pointY, let currentIndex: Int = currentPoint.index {
                
                if !boolData[y][x] {
                    return CGPoint(x: currentX, y: currentY)
                }
                
                 let leftIndex = currentIndex - 1
                 let rightIndex = currentIndex + 1
                 let topIndex = currentIndex - width
                 let bottomIndex = currentIndex + width
                
                 if currentX > 1 {
                    if !boolData[y][x-1] {
                        return CGPoint(x: currentX - 1, y: currentY)
                    }
                     point.append(PointNode(pointX: currentX - 1, pointY: currentY, index: leftIndex))
                 }
                 if currentX < width - 1 {
                    if !boolData[y][x+1] {
                        return CGPoint(x: currentX + 1, y: currentY)
                    }
                     point.append(PointNode(pointX: currentX + 1, pointY: currentY, index: rightIndex))
                 }
                 if currentY > 1 {
                    if !boolData[y-1][x] {
                        return CGPoint(x: currentX, y: currentY - 1)
                    }
                     point.append(PointNode(pointX: currentX, pointY: currentY - 1, index: topIndex))
                 }
                 if currentY < height - 1 {
                    if !boolData[y+1][x] {
                        return CGPoint(x: currentX, y: currentY + 1)
                    }
                     point.append(PointNode(pointX: currentX, pointY: currentY + 1, index: bottomIndex))
                 }
             }
        }
        return touchPointInImage
    }
}

