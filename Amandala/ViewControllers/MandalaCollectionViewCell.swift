//
//  MandalaCollectionViewCell.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

class MandalaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: ImageViewWithCorner!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    /// gets the image path and adds it to the cell
    /// - Parameter path: path to the desired picture
    func setImage(path: String?) {
        if let pathFile = path {
            imageView.image = UIImage(contentsOfFile: pathFile)
        }
    }
        
    
    /// adds a shadow around the image
    fileprivate func addShadow() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
    }

    func getImage() -> UIImage? {
        return imageView.image
    }
}
