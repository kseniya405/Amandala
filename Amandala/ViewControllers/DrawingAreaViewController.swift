//
//  ViewController.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 02.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import ChromaColorPicker
import DeviceCheck

/// cell identifier of the CollectionView palette
fileprivate let identifierCollectionViewCell = "ChooseColorCollectionViewCell"

/// number of lines in a palette of color
fileprivate let numSectionPallete = 2

/// number of colors in one line of a palette
fileprivate let numItemInSection = 9

/// bottom indent from palette line
fileprivate var insetsCollectionView: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

/// default colors in the palette of colors (first row of the palette)
fileprivate let defaultColors = [Colors.brown, Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.darkGreen, Colors.blue, Colors.darkBlue]

/// options of the selected button in the tool bar
fileprivate enum TypeTapButton: Int {
    case fill
    case eraser
    case palette
    case dropper
}

fileprivate let alphaPickerWidthForIPad: CGFloat = 40
fileprivate let alphaPickerWidthForIPhone: CGFloat = 20


/// shows which button is currently selected
fileprivate var typeButtonTap = TypeTapButton.fill

/// Controls the area screen for drawing
class DrawingAreaViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mandalaImageView: PaintingImageView!    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.minimumZoomScale = 1.0
            imageScrollView.maximumZoomScale = 20
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
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
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
    
    @IBOutlet weak var dropperButton: UIButton!   {
        didSet {
            dropperButton.addTarget(self, action: #selector(dropperButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var alphaPickerView: AlphaPicker! {
        didSet {
            alphaPickerView.currentColor = Colors.brown
        }
    }
    
    @IBOutlet weak var alphaPickerWidth: NSLayoutConstraint!
    
    @IBOutlet weak var alphaColorIndicator: UIViewCircle! {
        didSet {
            alphaColorIndicator.layer.borderWidth = 1
            alphaColorIndicator.layer.borderColor = UIColor.black.cgColor
            
            alphaColorIndicator.layer.shadowColor = UIColor.black.cgColor
            alphaColorIndicator.layer.shadowOffset = CGSize(width: 10, height: 10)
            alphaColorIndicator.layer.shadowOpacity = 0.5
            alphaColorIndicator.layer.shadowRadius = 10
        }
    }
    
    
    /// colors in the palette of colors that the user selected (the second row of the palette)
    var customColors = [UIColor]()
    
    /// selected color for painting the area
    var replacementColor: UIColor = Colors.brown
    
    /// index of the selected cell in colorPalleteButton
    var selectedCell: IndexPath?
    
    /// if the image was opened from the gallery screen, then this is the path to this image in the file manager.
    /// need to delete the previous version of the picture after saving the new
    var pathSelectedImagesFromGallery: String?
    
    /// mandala Image
    var image = UIImage()
    
    /// indicates whether the selected color is a color from the palette
    var isColorPalette = true
    
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alphaPickerView.delegate = self
        alphaPickerView.layer.borderWidth = 1
        alphaPickerView.layer.borderColor = UIColor.black.cgColor
        
        imageScrollView.delegate = self
        
        selectedCell = IndexPath(item: 0, section: 0)
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
        paletteCollectionView.register(UINib(nibName: identifierCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: identifierCollectionViewCell)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
        mandalaImageView.addGestureRecognizer(tap)
        mandalaImageView.isUserInteractionEnabled = true
        mandalaImageView.image = image
        
        alphaPickerWidth.constant = UIDevice().model == "iPad" ? alphaPickerWidthForIPad : alphaPickerWidthForIPhone
        
        
        
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
        saveImage()
        goToLibraryScreen()
    }
    
    @objc func shareDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        initialViewController.setImage(image: mandalaImageView.image)
        self.navigationController?.pushViewController(initialViewController, animated: false)
    }
    
    /// Activates the fill button, traces the selected color (default - Colors.brown)
    @objc func fillButtonDidTap() {
        
        switch typeButtonTap {
        case .dropper:
            typeButtonTap = .fill
            changeImageOfButtons()
            return
        case .fill:
            return
        default:
            if selectedCell == nil {
                replacementColor = Colors.brown
                alphaPickerView.currentColor = replacementColor
            }
            
            typeButtonTap = .fill
            changeImageOfButtons()
            
            if let deselectedCell = selectedCell {
                paletteCollectionView.reloadItems(at: [deselectedCell])
            } else {
                selectedCell = IndexPath(item: 0, section: 0)
                paletteCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
        
        
        
    }
    
    
    /// Activates the earaser button, removes the stroke of the currently selected cell
    @objc func earaserButtonDidTap() {
        typeButtonTap = .eraser
        
        if let deselectedCell = selectedCell {
            paletteCollectionView.reloadItems(at: [deselectedCell])
        }
        changeImageOfButtons()
    }
    
    /// Activates the
    @objc func dropperButtonDidTap() {
        typeButtonTap = .dropper
        
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
        
        typeButtonTap = .palette
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
        
        if typeButtonTap == .dropper {
            replacementColor = mandalaImageView.getCurrentColor(point) ?? .red
            alphaPickerView.currentColor = replacementColor
            isColorPalette = false
        } else {
            let newColor = typeButtonTap == .eraser ? .white : replacementColor
            mandalaImageView.buckerFill(point, replacementColor: newColor)
        }
        
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func setPathImagesFromGallery(path: String?) {
        pathSelectedImagesFromGallery = path
    }
    
    /// Changes the image on the buttons, depending on which one is selected
    /// Example:
    ///     nameButton.image = UIImage(named: "nameTap" / "nameUntap" )
    func changeImageOfButtons() {
        let imageFillName = typeButtonTap == .fill ? "fillTap" : "fillUntap"
        let imageEraserName = typeButtonTap == .eraser ? "eraserTap" : "eraserUntap"
        let imagePalleteName = typeButtonTap == .palette ? "palleteTap" : "palleteUntap"
        let imagePipetteName = typeButtonTap == .dropper ? "dropperTap" : "dropperUntap"
        
        fillButton.setImage(UIImage(named: imageFillName), for: .normal)
        eraserButton.setImage(UIImage(named: imageEraserName), for: .normal)
        colorPalleteButton.setImage(UIImage(named: imagePalleteName), for: .normal)
        dropperButton.setImage(UIImage(named: imagePipetteName), for: .normal)
    }
    
    
    /// Saves an image in a directory
    func saveImage() {
        
        if let path = pathSelectedImagesFromGallery {
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                debugPrint("failed to read directory – bad permissions, perhaps?")
            }
        }
        
        
        let fileManager = FileManager.default
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyhhmmssa"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(convertedDate).png")
        let image = mandalaImageView.image
        let imageData = image?.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
    }
    
    func goToLibraryScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! CustomTabBarViewController
        initialViewController.selectedIndex = 1
        self.navigationController?.pushViewController(initialViewController, animated: false)
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
        
        let cellIsSelected = (typeButtonTap == .fill) && (indexPath == selectedCell) && isColorPalette
        
        if indexPath.item < numItemInSection && indexPath.section == 0 {
            cell.setParameters(color: defaultColors[indexPath.item], cellIsSelected: cellIsSelected)
        } else if indexPath.section == 1 && indexPath.item < customColors.count {
            cell.setParameters(color: customColors[indexPath.item], cellIsSelected: cellIsSelected)
        } else if indexPath.section == 1 && indexPath.item == customColors.count {
            cell.addColor()
        } else {
            cell.clearCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) - CGFloat(numItemInSection) * 5 / CGFloat(numItemInSection) - 20
        let height = collectionView.bounds.size.height / 2 - insetsCollectionView.bottom
        return width < height ? CGSize(width: width, height: width) : CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 || (indexPath.section == 1 && indexPath.item <= customColors.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = (collectionView.frame.width) - CGFloat(numItemInSection) * 5 / CGFloat(numItemInSection) - 20
        let height = collectionView.bounds.size.height / 2 - insetsCollectionView.bottom
        let size = width < height ? width : height
        
        let horizontalSpace = collectionView.bounds.size.width - CGFloat(defaultColors.count - 1) * 5 - CGFloat(defaultColors.count) * size
        insetsCollectionView.left = horizontalSpace / 2
        insetsCollectionView.right = horizontalSpace / 2
        
        return insetsCollectionView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isColorPalette = true
        
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
        typeButtonTap = .fill
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
        
        if typeButtonTap != .palette {
            customColors.append(chooseColor)
            addСolorCell()
        } else {
            isColorPalette = false
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
    func didBeginHandleTouch() {
        alphaColorIndicator.isHidden = false
    }
    
    func didEndHandleTouch() {
        alphaColorIndicator.isHidden = true
    }
    
    func valuePicked(_ color: UIColor) {
        replacementColor = color
        alphaColorIndicator.backgroundColor = color
    }
}
