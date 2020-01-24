//
//  UIImage + Resized.swift
//  Amandala
//
//  Created by Kseniia Shkurenkoon 10.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
