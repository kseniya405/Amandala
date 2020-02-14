//
//  chooseColorCollectionViewCell.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 14.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit


/// cell color palette, usually with the selected color / or image "add"
class ChooseColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundColorView: UIViewCircle!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "add")
        }
    }
    @IBOutlet weak var checkImage: UIImageView! {
        didSet {
            checkImage.image = UIImage(named: "checkmark")
            checkImage.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    /// accepts cell parameters
    /// - Parameters:
    ///   - color: selected color
    ///   - cellIsSelected: indicates whether this cell is selected
    func setParameters(color: UIColor? = nil, cellIsSelected: Bool) {
        if color != nil {
            backgroundColorView.backgroundColor = color
            imageView.isHidden = true
        }
        makeSelect(makeSelect: cellIsSelected)
    }
    
    
    /// draws / deletes boarder
    /// - Parameter makeBoard: whether there is a boarder
    func makeSelect(makeSelect: Bool) {
//        backgroundColorView.layer.borderWidth = makeSelect ? 3 : 0
//        backgroundColorView.layer.borderColor = UIColor.black.cgColor
        checkImage.isHidden = !makeSelect
    }
    
    /// cleans the cell
    func clearCell() {
        makeSelect(makeSelect: false)
        backgroundColorView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    /// cell  with image "add"
    func addColor() {
        backgroundColorView.backgroundColor = .clear
         imageView.image = UIImage(named: "add")
        makeSelect(makeSelect: false)
    }
    

}
