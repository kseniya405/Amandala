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
    
    @IBOutlet weak var undoButton: UIButton! {
        didSet {
            undoButton.addTarget(self, action: #selector(undoDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var redoButton: UIButton! {
           didSet {
               redoButton.addTarget(self, action: #selector(redoDidTap), for: .touchUpInside)
           }
       }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
//            saveButton.addTarget(self, action: #selector(saveDidTap), for: .touchUpInside)
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
    
    @IBOutlet weak var saturationView: SaturationPicker!
    

    
    let defaultColors = [Colors.brown, Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.darkGreen, Colors.blue, Colors.darkBlue]
    var customColors = [UIColor]()
    
    var replacementColor: UIColor = Colors.brown
    var prevColor: UIColor?
    
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
        
        saturationView.currentColor = Colors.brown
        saturationView?.delegate = self

        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 10
        
        selectedCell = IndexPath(item: 0, section: 0)
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
        paletteCollectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        mandalaImageView.addGestureRecognizer(tap)
        mandalaImageView.image = UIImage(named: pngImageName)
        mandalaImageView.isUserInteractionEnabled = true
    }
    
    @objc func backButtonDidTap() {
                mandalaImageView.image = UIImage(named: pngImageName)
    }
    
    @objc func fillButtonDidTap() {
        if selectedCell == nil {
            selectedCell = IndexPath(item: 0, section: 0)
        }
        typeButtonTap = TypeButton.fill.rawValue
        collectionView(self.paletteCollectionView, didSelectItemAt: selectedCell!)
        changeImageOfButtons()
    }
    
    @objc func earaserButtonDidTap() {
        typeButtonTap = TypeButton.eraser.rawValue
        if let deselectedCell = selectedCell {
             paletteCollectionView.reloadItems(at: [deselectedCell])
        }
        selectedCell = nil
        replacementColor = .white
        changeImageOfButtons()
    }
    
    @objc func paletteButtonDidTap() {
        let colorPicker = ColorPickerViewController(nibName: "ColorPickerViewController", bundle: nil)
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
        
        typeButtonTap = TypeButton.palette.rawValue
        changeImageOfButtons()
    }
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mandalaImageView)
        mandalaImageView.buckerFill(point, replacementColor: replacementColor, prevColor: prevColor)
        prevColor = replacementColor
    }
    
    @objc func undoDidTap() {
        mandalaImageView.undo()
    }
    
    @objc func redoDidTap() {
        mandalaImageView.redo()
    }
    
    func changeImageOfButtons() {
        let imageFillName = typeButtonTap == TypeButton.fill.rawValue ? "fillTap" : "fillUntap"
        let imageEraserName = typeButtonTap == TypeButton.eraser.rawValue ? "eraserTap" : "eraserUntap"
        let imagePalleteName = typeButtonTap == TypeButton.palette.rawValue ? "palleteTap" : "palleteUntap"
        
        fillButton.setImage(UIImage(named: imageFillName), for: .normal)
        eraserButton.setImage(UIImage(named: imageEraserName), for: .normal)
        colorPalleteButton.setImage(UIImage(named: imagePalleteName), for: .normal)
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
        } else if indexPath.section == 1 && indexPath.item < customColors.count {
            cell.setParameters(color: customColors[indexPath.item], cellIsSelected: indexPath == selectedCell)
        } else if indexPath.section == 1 && indexPath.item == customColors.count {
            print("addColor", indexPath)
            cell.addColor()
        } else {
            print("clear color", indexPath)
            cell.clearCell()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 || (indexPath.section == 1 && indexPath.item <= customColors.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 8 * 5)/9
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        typeButtonTap = TypeButton.fill.rawValue
        changeImageOfButtons()
        
        if let deselectedCell = selectedCell {
            selectedCell = nil
            collectionView.deselectItem(at: deselectedCell, animated: true)
            collectionView.reloadItems(at: [deselectedCell])
        }
        selectedCell = indexPath
        collectionView.reloadItems(at: [indexPath])
        if indexPath.section == 0 || (indexPath.section == 1 && indexPath.item < customColors.count) {
            
            replacementColor = indexPath.section == 0 ? defaultColors[indexPath.item] : customColors[indexPath.item]
            saturationView.currentColor = replacementColor
            selectedCell = indexPath
            collectionView.reloadItems(at: [indexPath])
            
        } else if (indexPath.section == 1 && indexPath.item == customColors.count) {
            
            let colorPicker = ColorPickerViewController(nibName: "ColorPickerViewController", bundle: nil)
            colorPicker.delegate = self
            self.present(colorPicker, animated: true, completion: nil)
            
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

extension DrawingAreaViewController: ColorPickerViewControllerDelegate {
    func colorPickerDidChooseColor(_ color: UIColor) {
        if let deselectedCell = selectedCell {
            selectedCell = nil
            paletteCollectionView.deselectItem(at: deselectedCell, animated: true)
            paletteCollectionView.reloadItems(at: [deselectedCell])
        }

        replacementColor = color
        saturationView.currentColor = color
        if typeButtonTap == TypeButton.fill.rawValue {
            customColors.append(color)
            selectedCell = IndexPath(item: 1, section: customColors.count - 1)
            paletteCollectionView.reloadItems(at: [IndexPath(item: 1, section: customColors.count - 1)])

        }
        
    }

}


extension DrawingAreaViewController: SaturationPickerDelegate {
    func valuePicked(_ color: UIColor) {
        replacementColor = color
    }
    
    
}
