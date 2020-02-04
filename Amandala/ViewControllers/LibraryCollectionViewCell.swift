//
//  MandalaCollectionViewCell.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: ImageViewWithCorner!

    @IBOutlet weak var sizeImageView: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow(self)
    }


    /// gets the image path and adds it to the cell
    /// - Parameter path: path to the desired picture
    func setImage(path: String?, size: CGFloat? = nil) {
        if let pathFile = path {
            imageView.image = UIImage(contentsOfFile: pathFile)
        }
        if let sizeImage = size {
            sizeImageView.constant = sizeImage
        } else {
            sizeImageView.constant = self.bounds.width - 20
        }
    }
        
    
    /// adds a shadow around the image
    fileprivate func addShadow(_ view: UIView) {
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4.0
    }

    func getImage() -> UIImage? {
        return imageView.image
    }
}
