//
//  GalleryViewController.swift
//  Amandala
//
//  Created by Денис Марков on 29.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        getPathsAllSaveImage()
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

extension GalleryViewController: UICollectionViewDelegate {
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! MandalaCollectionViewCell
        guard let imagePaths = saveImages, indexPath.row < imagePaths.count else {
            return cell
        }
        
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let imagePath = (documentsDirectory as NSString).appendingPathComponent(imagePaths[indexPath.item])

        let path = Bundle.main.path(forResource: imagePaths[indexPath.item], ofType: nil)

        cell.setImage(path: imagePath)
        return cell
    }
    
//    func getImage(imageName : String)-> UIImage{
//            let fileManager = FileManager.default
//    // Here using getDirectoryPath method to get the Directory path
//        
//            let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
//            if fileManager.fileExists(atPath: imagePath){
//                return UIImage(contentsOfFile: imagePath)!
//            }else{
//                print("No Image available")
//                return UIImage.init(named: "placeholder.png")! // Return placeholder image here
//            }
//        }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width / 2.5
        return CGSize(width: size, height: size)
    }
}
