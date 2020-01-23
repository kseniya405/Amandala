//
//  PaintingImageView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//
import Foundation
import UIKit

class PaintingImageView: UIImageView {
    
    fileprivate var borderData = [[Bool]]()
    
    let steps = LinkedList<MoveNode>()
    var tempSteps = LinkedList<MoveNode>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)


        //                configureLayer()
        //                alpha = 0
        //                configureBorderLayer()
    }
    
    
    fileprivate func configureLayer(){
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 10
        //        layer.cornerRadius = 20
    }
    
    func configureBorderLayer(){
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        borderLayer.borderColor = UIColor.red.cgColor
        borderLayer.borderWidth = 10
        layer.addSublayer(borderLayer)
    }
    
    func getBorder() -> [[Bool]] {
        return borderData
    }
    
    func setBorder()  {
        guard let image = self.image else {
            print("OOOPS, image not correct")
            return
        }
        
        let queue = DispatchQueue(label: "myQueue", qos: .userInteractive)
        queue.async {
        guard let cgImage = image.cgImage else {
            print("OOOPS, cgimage not correct")
            return
        }
        
        let dataSize = cgImage.width * cgImage.height * 4
        let pixelData = malloc(dataSize)
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear) else {
            print("Error allocating color space")
            return
        }
        guard let context = CGContext(data: pixelData, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: cgImage.width * 4 , space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            print("Context not create")
            return
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else { return }
        
        
        
        var boolData = [[Bool]]()
        //        var byteIndex: Int = 0
        //        var isBorder = false
        //        for index in 0...dataSize/4-1 {
        //            byteIndex = index * 4
        ////            let red = UInt(pixelData[byteIndex])
        ////            let green = UInt(pixelData[byteIndex + 1])
        ////            let blue = UInt(pixelData[byteIndex + 2])
        ////            isBorder = red + green + blue == 0
        ////            boolData.append(isBorder)
        //        }
        for y in 0 ..< cgImage.height {
            var boolDataRow = [Bool]()
            for x in 0 ..< cgImage.width {
                boolDataRow.append(self.isBorderPixel(x: x, y: y, inData: data))
//                print(isBorderPixel(x: x, y: y, inData: data) {
//                    print(true)
//                }
            }
            boolData.append(boolDataRow)
        }       
        
        print(boolData.count)
        self.borderData = boolData
            UIGraphicsEndImageContext()
        }
    }
    
    fileprivate func isBorderPixel(x: Int, y: Int ,inData data:UnsafeMutablePointer<UInt8>) -> Bool {
        guard let width = self.image?.size.width else {
            print("Error rgbComponentsAtPoint")
            return false
        }
        let pixelInfo = (Int(width) * y + x) * 3
        let red = UInt(data[pixelInfo])
        let green = UInt(data[pixelInfo + 1])
        let blue = UInt(data[pixelInfo + 2])
        return  red + green + blue == 0
    }
    
}
