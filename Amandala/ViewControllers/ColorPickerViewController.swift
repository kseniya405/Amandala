//
//  ColorPickerViewController.swift
//  Amandala
//
//  Created by Kseniia Shkurenko 22.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import Material
import ChromaColorPicker


public protocol ColorPickerViewControllerDelegate: class {
    
    /// reports that the color has been selected or closed ColorPicker
    /// - Parameter color: selected color
    func colorPickerDidChooseColor(_ color: UIColor?)
}

/// the class that invokes the Color Picker over the main view of the controller with dimming outside the Color Picker.
/// after choosing a color or pressing outside the Color Picker, closes
class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var colorPickerView: UIView!
    
    open weak var delegate: ColorPickerViewControllerDelegate?
    
    /// Custom UIViewController Transitions
    var transitioner = CAVTransitioner()
    
    /// ColorPicker
    var neatColorPicker = ChromaColorPicker()
    
    /// serves to track clicks out of ColorPicker
    private var tapOutsideRecognizer: UITapGestureRecognizer!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.66, height: UIScreen.main.bounds.width * 0.66)
        
        self.view.layoutIfNeeded()
        neatColorPicker.delegate = self
        colorPickerView.makeAllCorners()
        self.view.makeAllCorners()
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        neatColorPicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.neatColorPicker.stroke = 30
        self.neatColorPicker.padding = 30
        self.neatColorPicker.hexLabel.isHidden = true
        self.neatColorPicker.shadeSlider.isHidden = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.addSubview(neatColorPicker)
    }
    
    /// registers TapGestureRecognizer
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.tapOutsideRecognizer == nil) {
            self.tapOutsideRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBehind))
            self.tapOutsideRecognizer.numberOfTapsRequired = 1
            self.tapOutsideRecognizer.cancelsTouchesInView = false
            self.tapOutsideRecognizer.delegate = self
            self.view.window?.addGestureRecognizer(self.tapOutsideRecognizer)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.tapOutsideRecognizer != nil) {
            self.view.window?.removeGestureRecognizer(self.tapOutsideRecognizer)
            self.tapOutsideRecognizer = nil
        }
    }

    
    /// close ColorPickers
    func close(sender: AnyObject) {
        delegate?.colorPickerDidChooseColor(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Gesture methods to dismiss this with tap outside
    /// - Parameter sender: TapGestureRecognizer
    @objc func handleTapBehind(sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            let location: CGPoint = sender.location(in: self.view)
            
            if (!self.view.point(inside: location, with: nil)) {
                self.view.window?.removeGestureRecognizer(sender)
                self.close(sender: sender)
            }
        }
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension ColorPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: ChromaColorPickerDelegate
extension ColorPickerViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        delegate?.colorPickerDidChooseColor(color)
        self.dismiss(animated: true, completion: nil)
    }
}


