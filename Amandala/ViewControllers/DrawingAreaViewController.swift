//
//  ViewController.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 02.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import ChromaColorPicker

/// cell identifier of the CollectionView palette
fileprivate let identifierCollectionViewCell = "ChooseColorCollectionViewCell"

/// number of lines in a palette of color
fileprivate let numSectionPallete = 2

/// number of colors in one line of a palette
fileprivate let numItemInSection = 9

/// bottom indent from palette line
fileprivate let bottomInsetsCollectionView: CGFloat = 10

/// default colors in the palette of colors (first row of the palette)
fileprivate let defaultColors = [Colors.brown, Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.darkGreen, Colors.blue, Colors.darkBlue]

/// options of the selected button in the tool bar
fileprivate enum TypeTapButton: Int {
    case fill
    case eraser
    case palette
}

/// shows which button is currently selected
fileprivate var typeButtonTap = TypeTapButton.fill

/// Controls the area screen for drawing
class DrawingAreaViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mandalaImageView: PaintingImageView!    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.minimumZoomScale = 1.0
            imageScrollView.maximumZoomScale = 10
        }
    }
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
            saveButton.addTarget(self, action: #selector(saveDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var paletteCollectionView: UICollectionView!    
    
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
    
    @IBOutlet weak var alphaPickerView: AlphaPicker! {
        didSet {
            alphaPickerView.currentColor = Colors.brown
        }
    }
    
    /// colors in the palette of colors that the user selected (the second row of the palette)
    var customColors = [UIColor]()
    
    /// selected color for painting the area
    var replacementColor: UIColor = Colors.brown
    
    /// index of the selected cell in colorPalleteButton
    var selectedCell: IndexPath?
    
    var image = UIImage()
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alphaPickerView.delegate = self
        imageScrollView.delegate = self
        
        selectedCell = IndexPath(item: 0, section: 0)
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
        paletteCollectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        mandalaImageView.addGestureRecognizer(tap)
        mandalaImageView.isUserInteractionEnabled = true
        
        mandalaImageView.image = image
    }
    
    @objc func backButtonDidTap() {
        self.dismiss()
    }
    
    @objc func undoDidTap() {
        mandalaImageView.undo()
    }
    
    @objc func redoDidTap() {
        mandalaImageView.redo()
    }
    
    @objc func saveDidTap() {
        let fileManager = FileManager.default
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmssa"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(convertedDate).png")
        print(paths)
        let image = mandalaImageView.image
        let imageData = image?.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)

    }

    
    /// Activates the fill button, traces the selected color (default - Colors.brown)
    @objc func fillButtonDidTap() {
        
        if typeButtonTap != TypeTapButton.fill && selectedCell == nil {
            replacementColor = Colors.brown
            alphaPickerView.currentColor = replacementColor
        }
        
        typeButtonTap = TypeTapButton.fill
        changeImageOfButtons()
        
        if let deselectedCell = selectedCell {
            paletteCollectionView.reloadItems(at: [deselectedCell])
        } else {
            selectedCell = IndexPath(item: 0, section: 0)
            paletteCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    
    /// Activates the earaser button, removes the stroke of the currently selected cell
    @objc func earaserButtonDidTap() {
        typeButtonTap = TypeTapButton.eraser
        
        if let deselectedCell = selectedCell {
            paletteCollectionView.reloadItems(at: [deselectedCell])
        }
        changeImageOfButtons()
    }
    
    /// Activates the palette button, removes the stroke of the currently selected cell
    /// Сalls ColorPickerViewController,
    /// removes the stroke of the currently selected cell
    @objc func paletteButtonDidTap() {
        
        let colorPicker = ColorPickerViewController(nibName: "ColorPickerViewController", bundle: nil)
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
        
        typeButtonTap = TypeTapButton.palette
        changeImageOfButtons()
        
        if let deselectedCell = selectedCell {
            paletteCollectionView.reloadItems(at: [deselectedCell])
        }
    }
    
    /// Нandles the user’s swing to the drawing: when touched, calls the method of painting over the selected point with the selected color
    ///
    /// - Parameter gesture: recognizer attached to the drawing area
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mandalaImageView)
        let newColor = typeButtonTap == TypeTapButton.eraser ? .white : replacementColor
        mandalaImageView.buckerFill(point, replacementColor: newColor)
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    /// Changes the image on the buttons, depending on which one is selected
    /// Example:
    ///     nameButton.image = UIImage(named: "nameTap" / "nameUntap" )
    func changeImageOfButtons() {
        let imageFillName = typeButtonTap == TypeTapButton.fill ? "fillTap" : "fillUntap"
        let imageEraserName = typeButtonTap == TypeTapButton.eraser ? "eraserTap" : "eraserUntap"
        let imagePalleteName = typeButtonTap == TypeTapButton.palette ? "palleteTap" : "palleteUntap"
        
        fillButton.setImage(UIImage(named: imageFillName), for: .normal)
        eraserButton.setImage(UIImage(named: imageEraserName), for: .normal)
        colorPalleteButton.setImage(UIImage(named: imagePalleteName), for: .normal)
    }
    
    
    func saveImage() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("apple.jpg")
        let image = mandalaImageView.image
        let imageData = image?.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
}

//MARK: UIScrollView Delegate
extension DrawingAreaViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoom
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DrawingAreaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return defaultColors.count
        default:
            return customColors.count == defaultColors.count ? customColors.count : customColors.count + 1
        }
    }
    
    func numberOfSections(in: UICollectionView) -> Int {
        return numSectionPallete
    }
    
    /// Assigns all properties to the cell when it is updated
    ///
    /// - returns: cell with parameters assigned to it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCollectionViewCell, for: indexPath) as! ChooseColorCollectionViewCell
        
        let cellIsSelected = (typeButtonTap == TypeTapButton.fill) && indexPath == selectedCell
        
        if indexPath.item < numItemInSection && indexPath.section == 0 {
            cell.setParameters(color: defaultColors[indexPath.item], cellIsSelected: cellIsSelected)
        } else if indexPath.section == 1 && indexPath.item < customColors.count {
            cell.setParameters(color: customColors[indexPath.item], cellIsSelected: cellIsSelected)
        } else if indexPath.section == 1 && indexPath.item == customColors.count {
            cell.addColor()
            print([indexPath])
        } else {
            cell.clearCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (Int(collectionView.frame.width) - (numItemInSection - 1) * Int(bottomInsetsCollectionView)) / numItemInSection
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 || (indexPath.section == 1 && indexPath.item <= customColors.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: bottomInsetsCollectionView, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            updateCells(collectionView, indexPath)
        default:
            if indexPath.count <= numItemInSection {
                switch indexPath.item {
                case customColors.count:
                    let colorPicker = ColorPickerViewController(nibName: "ColorPickerViewController", bundle: nil)
                    colorPicker.delegate = self
                    self.present(colorPicker, animated: true, completion: nil)
                default:
                    updateCells(collectionView, indexPath)
                }
            }
            
        }
    }
    
    
    /// Selects the selected button - fillButton, removes the selection from the previous color, selects the current
    /// - Parameters:
    ///   - collectionView: paletteCollectionView
    ///   - indexPath: indexPath of the selected cell
    fileprivate func updateCells(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        typeButtonTap = TypeTapButton.fill
        changeImageOfButtons()
        
        if let deselectedCell = selectedCell {
            selectedCell = nil
            collectionView.reloadItems(at: [deselectedCell])
        }
        
        replacementColor = indexPath.section == 0 ? defaultColors[indexPath.item] : customColors[indexPath.item]
        alphaPickerView.currentColor = replacementColor
        selectedCell = indexPath
        collectionView.reloadItems(at: [indexPath])
    }
    
}

//MARK: ColorPickerViewControllerDelegate
extension DrawingAreaViewController: ColorPickerViewControllerDelegate {

    
    func colorPickerDidChooseColor(_ color: UIColor?) {
        
        guard let chooseColor = color else {
            fillButtonDidTap()
            return
        }
        
        replacementColor = chooseColor
        alphaPickerView.currentColor = chooseColor
        
        if typeButtonTap != TypeTapButton.palette {
            customColors.append(chooseColor)
            addСolorCell()
        }
    }
    
    
    /// Add new color to custom color palette row
    fileprivate func addСolorCell() {
        paletteCollectionView.performBatchUpdates({
            
            if let deselectedCell = selectedCell {
                selectedCell = nil
                paletteCollectionView.deselectItem(at: deselectedCell, animated: true)
                paletteCollectionView.reloadItems(at: [deselectedCell])
            }
            if customColors.count >= numItemInSection {
                paletteCollectionView.deleteItems(at: [IndexPath(item: customColors.count - 1, section: 1)])
            }
            selectedCell = IndexPath(item: customColors.count - 1, section: 1)
            paletteCollectionView.insertItems(at: [IndexPath(item: customColors.count - 1, section: 1)])
        }, completion: nil)
    }
}

//MARK: SaturationPickerDelegate
extension DrawingAreaViewController: AlphaPickerDelegate {
    func valuePicked(_ color: UIColor) {
        replacementColor = color
    }
}
