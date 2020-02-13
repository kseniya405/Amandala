//
//  MandalaCollectionViewCell.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

protocol MandalaCollectionViewCellDelegate {
    func editButtonDidTap()
    func shareButtonDidTap()
    func deleteButtonDidTap()
}

class MandalaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: ImageViewWithCorner!

    @IBOutlet weak var sizeImageView: NSLayoutConstraint!
    
    @IBOutlet weak var frontActionView: ViewWithCorner!
    @IBOutlet weak var editButton: RoundButton! {
        didSet {
            editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var shareButton: RoundButton! {
           didSet {
            shareButton.imageView?.contentScaleFactor = 0.5
               shareButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
           }
       }
    @IBOutlet weak var deleteButton: RoundButton! {
           didSet {
               deleteButton.addTarget(self, action: #selector(deleteDidTap), for: .touchUpInside)
           }
       }
    
    var delegate: MandalaCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        frontActionView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        addShadow(self, shadowSize: 4.0)
        addShadow(editButton, shadowSize: 2)
        addShadow(shareButton, shadowSize: 2)
        addShadow(deleteButton, shadowSize: 2)
        editButton.backgroundColor = Colors.coral
        shareButton.backgroundColor = Colors.coral
        deleteButton.backgroundColor = Colors.coral
        editButton.round(corners: .allCorners, radius: editButton.bounds.height / 2)
        shareButton.round(corners: .allCorners, radius: shareButton.bounds.height / 2)
        deleteButton.round(corners: .allCorners, radius: deleteButton.bounds.height / 2)
    }
    
    
    @objc func editDidTap() {
        delegate?.editButtonDidTap()
    }

    @objc func shareDidTap() {
        delegate?.shareButtonDidTap()
    }

    @objc func deleteDidTap() {
        delegate?.deleteButtonDidTap()
    }

    /// gets the image path and adds it to the cell
    /// - Parameter path: path to the desired picture
    func setImage(path: String?, size: CGFloat? = nil, isSelected: Bool? = false) {
        frontActionView.isHidden = !(isSelected ?? true)
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
    fileprivate func addShadow(_ view: UIView, shadowSize: CGFloat) {
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: shadowSize / 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = shadowSize
    }

    func getImage() -> UIImage? {
        return imageView.image
    }
}
