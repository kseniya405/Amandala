//
//  floodFillAlgorithmHelper.swift
//  Amandala
//
//  Created by Kseniia Shkurenkoon 16.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit
class RGBComponent {
    let red, green, blue: UInt8
    
    init(red: UInt8, green: UInt8, blue: UInt8){
        self.red = red
        self.green = green
        self.blue = blue
    }
    func equalToComponent(_ component:RGBComponent) -> Bool {
        if red == component.red && green == component.green && blue == component.blue{
            return true
        } else {
            return false
        }
    }
}
