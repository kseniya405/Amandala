//
//  RoundButton.swift
//  Amandala
//
//  Created by Денис Марков on 05.02.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.frame.width, height: self.frame.height))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
