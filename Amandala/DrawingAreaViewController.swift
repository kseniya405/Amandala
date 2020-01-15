//
//  ViewController.swift
//  Amandala
//
//  Created by Денис Марков on 02.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
//import PocketSVG
//import SwiftSVG
import SVGKit
//import PaintBucket

fileprivate let identifierCollectionViewCell = "ChooseColorCollectionViewCell"

class DrawingAreaViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mandalaImageView: PaintingImageView!    
    @IBOutlet weak var imageScrollView: UIScrollView!

    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var paletteCollectionView: UICollectionView!
    
    
    @IBOutlet weak var paletteCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBAction func tapForFill(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: mandalaImageView)
        mandalaImageView.buckerFill(point, replacementColor: replacementColor)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    var imageSet = UIImage(named: "11png")
    var replacementColor: UIColor = .blue
    let defaultColors = [Colors.burgundy, Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.darkGreen, Colors.blue, Colors.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 25.0
        
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
        
//        paletteCollectionViewFlowLayout.itemSize = CGSize(width: 20, height: 20)
        
        paletteCollectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.tapGesture(_:)))
        mandalaImageView.addGestureRecognizer(tap)
        
        //for transparent
//        let activityIndicator = self.view.showActivityIndicator()
//        DispatchQueue.main.async {
//            self.mandalaImageView.image = self.preparingImage(callback: { () -> (Void) in
//                self.view.stopActivityIndicator(activityIndicator: activityIndicator)
//            })
//        }
        
        mandalaImageView.image = imageSet
        mandalaImageView.isUserInteractionEnabled = true
    }
    

        
    @objc func backButtonDidTap() {
        mandalaImageView.image = imageSet
//        let activityIndicator = self.view.showActivityIndicator()
//        DispatchQueue.main.async {
//            self.mandalaImageView.image = self.preparingImage(callback: { () -> (Void) in
//                self.view.stopActivityIndicator(activityIndicator: activityIndicator)
//            })
//        }
    }
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mandalaImageView)
        mandalaImageView.buckerFill(point, replacementColor: .blue)
    }
    
    
    fileprivate func printDate(printString: String) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        print(" \(printString) : \(hour):\(minute):\(second)")
    }
    
    
    /**
     Processes the image of a mandala: composes a Boolean array with a border, converts a transparent background to white.
     - Parameter callback: indicates that the image has already loaded
     @return Image without transparent background
     */
    func preparingImage(callback: @escaping (() -> (Void)) ) -> UIImage? {
         printDate(printString: "Start load image")
        
        guard let image = imageSet, let cgImage = image.cgImage else {
            print("OOOPS, cgImage not correct")
            return nil
        }

        let dataSize = cgImage.width * cgImage.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        
        let context = CGContext(data: &pixelData,
                            width: cgImage.width,
                            height: cgImage.height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * cgImage.width,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        
        var boolData = [Bool]()
        var byteIndex: Int = 0
        var isBorder = false
        for index in 0...dataSize/4-1 {
            byteIndex = index * 4
            
            let red = UInt(pixelData[byteIndex])
            let green = UInt(pixelData[byteIndex + 1])
            let blue = UInt(pixelData[byteIndex + 2])
            let alpha = UInt(pixelData[byteIndex + 3])
            
            isBorder = alpha != 0 && red + green + blue == 3
            boolData.append(isBorder)
            if alpha == 0 {
                pixelData[byteIndex] = UInt8(255)
                pixelData[byteIndex + 1] = UInt8(255)
                pixelData[byteIndex + 2] = UInt8(255)
                pixelData[byteIndex + 3] = UInt8(255)
            }
        }
        
        mandalaImageView.setBorder(boolData: boolData)
        if let newCGImage = context?.makeImage() {
            callback()
            printDate(printString: "Finish load image")
            return UIImage(cgImage: newCGImage, scale: image.scale, orientation: .up)
        } else {
            callback()
            return image
        }
    }
    


}

// MARK : UIScrollView Delegate
extension DrawingAreaViewController: UIScrollViewDelegate {
    
    /// allows you to zoom the image
    /// - Parameter scrollView: selected scrollview that they are trying to scale now
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mandalaImageView
    }

}

//MARK: UICollectionView Delegate
extension DrawingAreaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func numberOfSections(in: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! ChooseColorCollectionViewCell
        if indexPath.row < 9 && indexPath.section == 0 {
            cell.setParameters(color: defaultColors[indexPath.row], cellIsSelected: false)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 8 * 5)/9
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        indexTable = indexPath.row
//        heightTable.constant = dataSize[indexTable].sizeType.count == 3 ? 240 : 160
//        chooseParcelSize.isHidden = true
//
//        parcelTypeTableView.beginUpdates()
//        parcelTypeTableView.reloadData()
//        parcelTypeTableView.endUpdates()
//        parcelTypeTableView.isHidden = false
//        delegate?.updateConstraintCell()
//
//        let selectCell = collectionView.cellForItem(at: indexPath) as! ParcelSizeTypeCollectionViewCell
//        selectCell.setBackgroundColor(color: lightGrayBackground)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
}
