//
//  File.swift
//  Amandala
//
//  Created by Денис Марков on 05.02.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation

/// Standard UIImageView, but with rounded corners
/// (rounding of the corners should occur during override func layoutSubviews ()), so just do not do this with the method
class ViewWithCorner: UIView {
      
    override func layoutSubviews() {
        self.makeAllCorners()
    }
}
