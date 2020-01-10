//
//  FloodImage.swift
//  ToneEditor-iOS
//
//  Created by Анатолий on 07.11.2017.
//  Copyright © 2017 Анатолий. All rights reserved.
//

import UIKit

class FloodImage: UIImageView {
    
    /// Filter Sensitivity
    var tolerance: Int = 100
    /// Pixel target color
    var newColor: UIColor = .blue
    /// Image setter
    var originImage: UIImage? {
        didSet {
            self.image = originImage
            self.setup()
        }
    }
    /// Touch position
    var pos = CGPoint(x: 0, y: 0)
    /// Includes anti-aliasing effect
    let antiAlias = false
    /// Representation of image data as an UInt8 Array
    var pixelData = [UInt8]()
    
    var boolData = [Bool]()
    var tempBoolData = [Bool]()
    
    /// Workspace of changing image data
    var context: CGContext!
    /// Representation UIImage in CGImage
    var cgImage: CGImage!
    
    /// Linked List
    var point = LinkedList<PointNode>()
    var antiAliasingPoints = LinkedList<PointNode>()
    
    /// Color
    var newColorCode: UInt!
    /// Color
    var oldColorCode: UInt!
    
    // New data color value's
    var newRed: UInt8 = 0
    var newGreen: UInt8 = 0
    var newBlue: UInt8 = 0
    var newAlpha: UInt8 = 0
    
    var bytesPerRow: Int!
    var bytesPerPixel: Int!
    var byteIndex: Int!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tapLocation = event?.allTouches?.first?.location(in: self)
        let width: CGFloat = CGFloat(Double(originImage?.cgImage?.width ?? 0))
        let height: CGFloat = CGFloat(Double(originImage?.cgImage?.height ?? 0))
        pos = CGPoint(x: (width / self.bounds.size.width ) * (tapLocation?.x)!,
                      y: (height / self.bounds.size.height) * (tapLocation?.y)!)
        print(pos)
        point.removeAll()
        antiAliasingPoints.removeAll()
        
        self.image = fillNewColor()
    }
    
    var pixelDataColor: CFData?
    var data: UnsafePointer<UInt8>?
    var width: Int = 0
    var height: Int = 0
    
    
    var oldRed: UInt8 = 0
    var oldGreen: UInt8 = 0
    var oldBlue : UInt8 = 0
    var oldAlfa : UInt8 = 0
    //MARK: -Setup image data-
    /// Extracting time-consuming data from an image
    fileprivate func setup () {
        imageData ()
        createNColor ()
        setupAlgoritm()
        
        pixelDataColor = (originImage?.cgImage!.dataProvider!.data!)!
        data = CFDataGetBytePtr(pixelDataColor)
        width = cgImage.width
        height = cgImage.height
    }
    
    fileprivate func imageData () {
        
        cgImage = originImage?.cgImage
        
        let dataSize = cgImage.width * cgImage.height * 4
        pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        
        context = CGContext(data: &pixelData,
                            width: Int(cgImage.width),
                            height: Int(cgImage.height),
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * Int(cgImage.width),
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        
        
        var byteIndex: Int = 0
        for index in 0...dataSize/4-1 {
            byteIndex = index * 4
            let red = UInt(pixelData[byteIndex])
            let green = UInt(pixelData[byteIndex + 1])
            let blue = UInt(pixelData[byteIndex + 2])
            let alpha = UInt(pixelData[byteIndex + 3])
            boolData.append(red + green + blue + alpha == 0)
        }
        
    }
    
    fileprivate func createNColor () {
        let components = newColor.cgColor.components!
        if newColor.cgColor.numberOfComponents == 2 {
            newBlue = UInt8(components[0] * 255)
            newGreen = newBlue
            newRed = newGreen
            newAlpha = UInt8(components[1] * 255)
        } else if newColor.cgColor.numberOfComponents == 4 {
            newRed = UInt8(components[0] * 255)
            newGreen = UInt8(components[1] * 255)
            newBlue = UInt8(components[2] * 255)
            newAlpha = 255
        }
        let tempRed =  UInt(newRed)
        let tempGreen =  UInt(newGreen)
        let tempBlue =  UInt(newBlue)
        let tempAlpha =  UInt(newAlpha)
        newColorCode = (tempRed << 24) | (tempGreen << 16) | (tempBlue << 8) | tempAlpha
    }
    
    fileprivate func setupAlgoritm() {
        bytesPerRow = Int(4 * cgImage!.width)
        bytesPerPixel = (cgImage?.bitsPerPixel)!/8
        byteIndex = (width * Int(pos.y)) + Int(pos.x)
    }
    
    //MARK: -Algoritm-
    
    func isSpace (x: Int, y: Int) -> Bool {
        let pixelInfo = width * y + x
        
        return pixelInfo < boolData.count && !boolData[pixelInfo]
    }
    
    fileprivate func fillNewColor () -> UIImage {
//        var currentProcessedPoints = [Int]()
        let x = Int(pos.x)
        let y = Int(pos.y)
        let startIndex = (width * y) + x
        if !boolData[startIndex] {
            let newCGImage = context?.makeImage()
            return UIImage(cgImage: newCGImage!, scale: originImage!.scale, orientation: .up)
        }
        let startBytesIndex = startIndex * 4
        oldRed = pixelData[startBytesIndex]
        oldGreen = pixelData[startBytesIndex + 1]
        oldBlue = pixelData[startBytesIndex + 2]
        oldAlfa = pixelData[startBytesIndex + 3]
        changeColor(index: startIndex)
        point.removeAll()
        point.append(PointNode(pointX: x, pointY: y, index: startIndex))
        
        tempBoolData = boolData
        
        while let currentPoint = point.removeLast(){
            if let currentX = currentPoint.pointX, let currentY = currentPoint.pointY, let currentIndex = currentPoint.index {
                let leftIndex = currentIndex - 1
                let rightIndex = currentIndex + 1
                let topIndex = currentIndex - width
                let bottomIndex = currentIndex + width
                if currentX > 1, checkIsColorToReplace(index: leftIndex) {
                    changeColor(index: leftIndex)
                    point.append(PointNode(pointX: currentX - 1, pointY: currentY, index: leftIndex))
                }
                if currentX < width - 1, checkIsColorToReplace(index: rightIndex) {
                     changeColor(index: rightIndex)
                    point.append(PointNode(pointX: currentX + 1, pointY: currentY, index: rightIndex))
                }
                if currentY > 1, checkIsColorToReplace(index: topIndex) {
                     changeColor(index: topIndex)
                    point.append(PointNode(pointX: currentX, pointY: currentY - 1, index: topIndex))
                }
                if currentY < height - 1, checkIsColorToReplace(index: bottomIndex) {
                     changeColor(index: bottomIndex)
                    point.append(PointNode(pointX: currentX, pointY: currentY + 1, index: bottomIndex))
                }
            }
        }
        // Create Image from Data
        
        let newCGImage = context?.makeImage()
        return UIImage(cgImage: newCGImage!, scale: originImage!.scale, orientation: .up)
    }
    
    func checkIsColorToReplace(index: Int) -> Bool {
        let bytesIndex = index * 4
        return (pixelData[bytesIndex] == oldRed) && (pixelData[bytesIndex + 1] == oldGreen)  && (pixelData[bytesIndex + 2] == oldBlue)
    }
    
    func changeColor(index: Int) {
        let currentBytesIndex = index * 4
        pixelData[currentBytesIndex] = UInt8(newRed)
        pixelData[currentBytesIndex + 1] = UInt8(newGreen)
        pixelData[currentBytesIndex + 2] = UInt8(newBlue)
        pixelData[currentBytesIndex + 3] = UInt8(newAlpha)
    }
    
    fileprivate func getColorCode(_ byteIndex: Int,_ pixelData: [UInt8]) -> UInt {
        let byteIndex = byteIndex * 4
        let red = UInt(pixelData[byteIndex])
        let green = UInt(pixelData[byteIndex + 1])
        let blue = UInt(pixelData[byteIndex + 2])
        let alpha = UInt(pixelData[byteIndex + 3])
        return (red<<24 | green<<16 | blue<<8 | alpha)
    }
    
    
    
    fileprivate func getColorCodeFromUIColor(_ color: UIColor) -> UInt {
        //Convert newColor to RGBA value so we can save it to image.
        let newColor = CIColor(color: color)
        let newRed = UInt(newColor.red * 255 + 0.5)
        let newBlue = UInt(newColor.blue * 255 + 0.5)
        let newGreen = UInt(newColor.green * 255 + 0.5)
        let newAlpha = UInt(newColor.alpha * 255 + 0.5)
        return ((newRed << 24) | (newGreen << 16) | (newBlue << 8) | newAlpha)
    }
    
    fileprivate func compareColor(byteIndex: Int) -> Bool {
        return boolData[byteIndex]
    }
    
}



