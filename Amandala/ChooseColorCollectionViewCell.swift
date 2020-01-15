//
//  chooseColorCollectionViewCell.swift
//  Amandala
//
//  Created by Денис Марков on 14.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

class ChooseColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundColorView: UIViewCircle!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "add")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(self.bounds)
    }
    
    func setParameters(color: UIColor? = nil, cellIsSelected: Bool) {
        if color != nil {
            backgroundColorView.backgroundColor = color
            imageView.isHidden = true
        } else {
            backgroundColorView.backgroundColor = Colors.lightGray
            imageView.isHidden = false
        }
    }

}
