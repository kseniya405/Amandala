
//
//  ColorPickerView.swift
//  Amandala
//
//  Created by Денис Марков on 20.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import ChromaColorPicker


/**
  Сlass for view that contains color picker.
  View features:
   rounded corners
   color picker completely fills the view
   since the corlor picker has a transparent background, the background is visible in the main view (white by default)
 
 var neatColorPicker - color picker itself
 */
class ColorPickerView: UIView {
    
    var neatColorPicker = ChromaColorPicker()
    
    
    /**
     
     */
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        
        neatColorPicker.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.neatColorPicker.stroke = 15
        self.neatColorPicker.hexLabel.isHidden = true
        self.neatColorPicker.shadeSlider.isHidden = true
    }

}
