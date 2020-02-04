//
//  GalleryViewController.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import DeviceCheck

fileprivate let identifierCollectionViewCell = "MandalaCollectionViewCell"

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var galleryLable: UILabel! {
        didSet {
            galleryLable.text = Strings.gallery
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var saveImages: [String]?
    var selectedCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        getPathsAllSaveImage()
    }
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 30)
    }
    
    func getPathsAllSaveImage(){
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)
            saveImages = items
        } catch {
            debugPrint("failed to read directory – bad permissions, perhaps?")
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let deselectedCell = selectedCell else {
            selectedCell = indexPath
            collectionView.reloadItems(at: [indexPath])
            return
        }
        
        selectedCell = nil
        collectionView.reloadItems(at: [deselectedCell])
        
        selectedCell = deselectedCell == indexPath ? nil : indexPath
        collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! MandalaCollectionViewCell
        guard let imagePaths = saveImages, indexPath.row < imagePaths.count else {
            return cell
        }
        let isSelected = selectedCell == indexPath
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let imagePath = (documentsDirectory as NSString).appendingPathComponent(imagePaths[indexPath.item])
        
        cell.delegate = self
        cell.setImage(path: imagePath, isSelected: isSelected)
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let device = UIDevice.current.model
        let coefficient: CGFloat = device == "iPad" ? 3 : 2
        let size = UIScreen.main.bounds.size.width / coefficient -  20
        return CGSize(width: size, height: size)
    }
    
}


extension GalleryViewController: MandalaCollectionViewCellDelegate {
    func editButtonDidTap() {
        guard let indexSelectedCell = selectedCell else { return }
        let cell = collectionView.cellForItem(at: indexSelectedCell) as! MandalaCollectionViewCell
        let image = cell.getImage()
        guard let chooseImage = image else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "DrawingAreaViewController") as! DrawingAreaViewController
        initialViewController.setImage(image: chooseImage)
        self.navigationController?.pushViewController(initialViewController, animated: false)
    }
    
    func shareButtonDidTap() {
        guard let indexSelectedCell = selectedCell else { return }
        let cell = collectionView.cellForItem(at: indexSelectedCell) as! MandalaCollectionViewCell
        let image = cell.getImage()
        guard let chooseImage = image else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        initialViewController.setImage(image: chooseImage)
        self.navigationController?.pushViewController(initialViewController, animated: false)
        
    }
    
    func deleteButtonDidTap() {
        
        let fileManager = FileManager.default
        guard let imagePaths = saveImages, let indexPath = selectedCell, indexPath.item < imagePaths.count else { return }
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let imagePath = (documentsDirectory as NSString).appendingPathComponent(imagePaths[indexPath.item])
        
        do {
            try fileManager.removeItem(atPath: imagePath)
        } catch {
            debugPrint("failed to read directory – bad permissions, perhaps?")
        }
        
        selectedCell = nil
        getPathsAllSaveImage()
        collectionView.reloadData()
    }
    
    
}
