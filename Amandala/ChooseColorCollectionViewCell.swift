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
        imageView.image = UIImage(named: "add")
    }
    
    func setParameters(color: UIColor? = nil, cellIsSelected: Bool) {
        if color != nil {
            backgroundColorView.backgroundColor = color
            imageView.isHidden = true
        }
        makeBorder(makeBoard: cellIsSelected)
    }
    
    func makeBorder(makeBoard: Bool) {
        backgroundColorView.layer.borderWidth = makeBoard ? 3:0
        backgroundColorView.layer.borderColor = UIColor.black.cgColor
    }
    
    func clearCell() {
        makeBorder(makeBoard: false)
        imageView.image = nil
        backgroundColorView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        makeBorder(makeBoard: false)
        backgroundColorView.backgroundColor = .clear
        imageView.image = UIImage(named: "add")
    }
    
    func addColor() {
        makeBorder(makeBoard: false)
        print("+")
        imageView.image = UIImage(named: "add")
    }
    

}
