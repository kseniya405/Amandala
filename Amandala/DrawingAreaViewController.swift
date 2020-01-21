//
//  ViewController.swift
//  Amandala
//
//  Created by Денис Марков on 02.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import SVGKit
import ChromaColorPicker
import SwiftHUEColorPicker

fileprivate let identifierCollectionViewCell = "ChooseColorCollectionViewCell"
fileprivate let pngImageName = "15-2500"

class DrawingAreaViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mandalaImageView: PaintingImageView!    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var viewForZoom: UIView!
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var paletteCollectionView: UICollectionView!
    
    @IBOutlet weak var paletteCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    @IBOutlet weak var fillButton: UIButton! {
        didSet {
            fillButton.addTarget(self, action: #selector(fillButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var eraserButton: UIButton!  {
        didSet {
            eraserButton.addTarget(self, action: #selector(earaserButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var colorPalleteButton: UIButton!  {
        didSet {
            colorPalleteButton.addTarget(self, action: #selector(paletteButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var saturationView: UIView!
    
    @IBOutlet weak var colorPickerView: ColorPickerView! {
        didSet {
            colorPickerView.neatColorPicker.delegate = self
        }
    }
    let saturationPicker = SwiftHUEColorPicker()

    
    let defaultColors = [Colors.brown, Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.darkGreen, Colors.blue, Colors.darkBlue]
    
    var replacementColor: UIColor = Colors.brown {
        didSet {
            saturationPicker.currentColor = replacementColor
        }
    }
    
    enum TypeButton: Int {
        case fill = 0
        case eraser = 1
        case palette = 2
    }
    
    var typeButtonTap = 0;
    
    var selectedCell: IndexPath?
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.addSubview(colorPickerView.neatColorPicker)
        self.colorPickerView.slideOut(from: .up)
        
        saturationPicker.direction = .vertical
        saturationPicker.type = .saturation
        saturationView.addSubview(saturationPicker)
        
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 50
        
        selectedCell = IndexPath(item: 0, section: 0)
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
        paletteCollectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        mandalaImageView.addGestureRecognizer(tap)
        mandalaImageView.isUserInteractionEnabled = true
    }
    
    @objc func backButtonDidTap() {
                mandalaImageView.image = UIImage(named: pngImageName)
    }
    
    @objc func fillButtonDidTap() {
        selectedCell = IndexPath(item: 0, section: 0)
        typeButtonTap = TypeButton.fill.rawValue
        collectionView(self.paletteCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        changeImageOfButtons()
    }
    
    @objc func earaserButtonDidTap() {
        typeButtonTap = TypeButton.eraser.rawValue
        selectedCell = nil
        paletteCollectionView.reloadData()
        replacementColor = .white
        changeImageOfButtons()
    }
    
    @objc func paletteButtonDidTap() {
        typeButtonTap = TypeButton.palette.rawValue
        colorPickerView.slideOut(from: .up)


        changeImageOfButtons()
        //TO DO : do colorPicker
    }
    
    
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mandalaImageView)
        mandalaImageView.buckerFill(point, replacementColor: replacementColor)
    }
    
    
    func changeImageOfButtons() {
        let imageFillName = typeButtonTap == TypeButton.fill.rawValue ? "fillTap" : "fillUntap"
        let imageEraserName = typeButtonTap == TypeButton.eraser.rawValue ? "eraserTap" : "eraserUntap"
        let imagePalleteName = typeButtonTap == TypeButton.palette.rawValue ? "palleteTap" : "palleteUntap"
        
        fillButton.setImage(UIImage(named: imageFillName), for: .normal)
        eraserButton.setImage(UIImage(named: imageEraserName), for: .normal)
        colorPalleteButton.setImage(UIImage(named: imagePalleteName), for: .normal)
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
    func preparingImage(image: UIImage?, callback: @escaping ((UIImage?) -> (Void)) ) -> UIImage? {
        printDate(printString: "Start load image")
        
        guard let image = image, let cgImage = image.cgImage else {
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
        
        //        var boolData = [Bool]()
        //        var isBorder = false
        //        var copyPixeldata = Data(pixelData)
        
        var byteIndex: Int = 0
        
        for index in 0...dataSize/4-1 {
            byteIndex = index * 4
            //
            //            let red = UInt(pixelData[byteIndex])
            //            let green = UInt(pixelData[byteIndex + 1])
            //            let blue = UInt(pixelData[byteIndex + 2])
            let alpha = UInt(pixelData[byteIndex + 3])
            //
            //            isBorder = alpha != 0 && red + green + blue == 3
            //            boolData.append(isBorder)
            if alpha <= UInt8(50) {
                pixelData[byteIndex] = UInt8(255)
                pixelData[byteIndex + 1] = UInt8(255)
                pixelData[byteIndex + 2] = UInt8(255)
                //                pixelData[byteIndex + 3] = UInt8(255)
            } else if alpha <= UInt8(160) {
                pixelData[byteIndex] = UInt8(170)
                pixelData[byteIndex + 1] = UInt8(170)
                pixelData[byteIndex + 2] = UInt8(170)
                //                pixelData[byteIndex + 3] = UInt8(255)
            }
            //            if alpha <= 255 {
            //                pixelData[byteIndex] = UInt8(255 - alpha/20)
            //                pixelData[byteIndex + 1] = UInt8(255 - alpha/20)
            //                pixelData[byteIndex + 2] = UInt8(255 - alpha/20)
            //            }
            pixelData[byteIndex + 3] = UInt8(255)
            
        }
        
        //        mandalaImageView.setBorder(boolData: boolData)
        if let newCGImage = context?.makeImage() {
            callback(UIImage(cgImage: newCGImage, scale: image.scale, orientation: .up))
            printDate(printString: "Finish load image")
            return UIImage(cgImage: newCGImage, scale: image.scale, orientation: .up)
        } else {
            callback(image)
            return image
        }
    }
    
    
}

//MARK: UIScrollView Delegate
extension DrawingAreaViewController: UIScrollViewDelegate {
    
    /// allows you to zoom the image
    /// - Parameter scrollView: selected scrollview that they are trying to scale now
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoom
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
        
        if indexPath.item < 9 && indexPath.section == 0 {
            cell.setParameters(color: defaultColors[indexPath.item], cellIsSelected: indexPath == selectedCell)
            print("background ", indexPath )
        } else if indexPath.section == 1 && indexPath.item != 0 {
            cell.clearCell()
            print("clearCell", indexPath)
        } else {
            //
            print("+ ", indexPath)
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return typeButtonTap == TypeButton.fill.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 8 * 5)/9
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let deselectedCell = selectedCell {
            selectedCell = nil
            collectionView.deselectItem(at: deselectedCell, animated: true)
            collectionView.reloadItems(at: [deselectedCell])
        }
        
        if indexPath.section == 0 {
            replacementColor = defaultColors[indexPath.item]
            selectedCell = indexPath
            paletteCollectionView.reloadItems(at: [indexPath])
            //        indexTable = indexPath.row
            //        heightTable.constant = dataSize[indexTable].sizeType.count == 3 ? 240 : 160
            //        chooseParcelSize.isHidden = true
            //
            //        parcelTypeTableView.beginUpdates()
            //        parcelTypeTableView.reloadData()
            //        parcelTypeTableView.endUpdates()
            //        parcelTypeTableView.isHidden = false
            //        delegate?.updateConstraintCell()
            
        } else {
            //
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedCell = nil
        paletteCollectionView.reloadItems(at: [indexPath])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        selectedCell = nil
        paletteCollectionView.reloadItems(at: [indexPath])
        return true
    }
}

extension DrawingAreaViewController: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        selectedCell = nil
        paletteCollectionView.reloadData()
        replacementColor = color
        colorPickerView.slideOut(from: .up)
    }
}
