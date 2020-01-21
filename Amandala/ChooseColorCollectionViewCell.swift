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
    }
    
    func setParameters(color: UIColor? = nil, cellIsSelected: Bool) {
        if color != nil {
            backgroundColorView.backgroundColor = color
            imageView.isHidden = true
            if cellIsSelected {
//                backgroundColorView.
            }
        } else {
            backgroundColorView.backgroundColor = Colors.lightGray
            imageView.isHidden = false
        }
        backgroundColorView.layer.borderWidth = cellIsSelected ? 3:0
        backgroundColorView.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeBorder(makeBoard: Bool) {
        backgroundColorView.layer.borderWidth = makeBoard ? 3:0
        backgroundColorView.layer.borderColor = UIColor.black.cgColor
    }
    
    func clearCell() {
        imageView.image = nil
        backgroundColorView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        backgroundColorView.backgroundColor = .clear
    }

}
