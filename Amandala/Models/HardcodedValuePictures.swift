//
//  hardcodedValeryPictures.swift
//  Amandala
//
//  Created by Денис Марков on 28.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit

enum HeaderType {
    case complex
    case easy
    case medium
    case special
}

class HardcodedValuePictures: NSCoder {
    var header: String = Strings.easy
    var numImage = 16
    
    init(header: HeaderType) {
        switch header {
        case .easy:
            self.header = Strings.easy
            self.numImage = 16
        case .medium:
            self.header = Strings.medium
            self.numImage = 21
        case .special:
            self.header = Strings.special
            self.numImage = 13
        default:
            self.header = Strings.complex
            self.numImage = 15
        }
    }
}
