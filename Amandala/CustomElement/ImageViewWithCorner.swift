//
//  ImageViewWithCornerAndShadow.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit


/// Standard UIImageView, but with rounded corners
/// (rounding of the corners should occur during override func layoutSubviews ()), so just do not do this with the method
class ImageViewWithCorner: UIImageView {
      
    override func layoutSubviews() {
        self.makeAllCorners()
    }
}
