//
//  LibraryTableViewCell.swift
//  Amandala
//
//  Created by Денис Марков on 28.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

fileprivate let identifierCollectionViewCell = "LibraryCollectionViewCell"


protocol LibraryTableCellDelegate {
    func imageDidChange(image: UIImage?)
}

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var headerName: String?
    var numImagesInSection = 0
    var delegate: LibraryTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
    }
    
    func setHeader(header: HardcodedValuePictures) {
        headerName = header.header
        numImagesInSection = header.numImage
    }
    
    
}

extension LibraryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let cell = collectionView.cellForItem(at: indexPath) as! LibraryCollectionViewCell
        let image = cell.getImage()
        delegate?.imageDidChange(image: image)
    }
    
}

extension LibraryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numImagesInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! LibraryCollectionViewCell
        if indexPath.row < numImagesInSection {
            let path = Bundle.main.path(forResource: "\(headerName ?? "medium")\(indexPath.row)", ofType: "png")
            cell.setImage(path: path, size: collectionView.bounds.width / 2.5)
        }
        return cell
    }
    
    
}

extension LibraryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size.width / 2.5
        return CGSize(width: size, height: size)
    }
}
