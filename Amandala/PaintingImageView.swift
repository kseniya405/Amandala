//
//  PaintingImageView.swift
//  Amandala
//
//  Created by Kseniia Shkurenkoon 16.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.

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
        let pixelData = malloc(dataSize) //  !!!!!!! memory issue
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            print("Error allocating color space")
            return
        }
        guard let context = CGContext(data: pixelData, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: cgImage.width * 4 , space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            print("Context not create")
            return
        }
        context.clear(CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else { return }
        
        
        var boolData = [[Bool]]()

        for y in 0 ..< cgImage.height {
            var boolDataRow = [Bool]()
            for x in 0 ..< cgImage.width {
                boolDataRow.append(self.isBorderPixel(x: x, y: y, inData: data, image: cgImage))
            }
            boolData.append(boolDataRow)
        }
        
        print(boolData.count)
        self.borderData = boolData

        }
    }
    
    fileprivate func isBorderPixel(x: Int, y: Int , inData data:UnsafeMutablePointer<UInt8>, image: CGImage) -> Bool {
        let pixelInfo = (Int(image.width) * y + x) * 4
  
        
        return  UInt8(data[pixelInfo + 1]) == UInt8(0) && UInt8(data[pixelInfo + 2]) == UInt8(0) && UInt8(data[pixelInfo + 3]) == UInt8(0)
    }
    
}
