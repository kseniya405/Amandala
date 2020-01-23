//
//  ColorPickerViewController.swift
//  Amandala
//
//  Created by Денис Марков on 22.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit
import Material
import ChromaColorPicker

public protocol ColorPickerViewControllerDelegate: class {
    func colorPickerDidChooseColor(_ color: UIColor)
}

class ColorPickerViewController: UIViewController, ChromaColorPickerDelegate, UIGestureRecognizerDelegate {

            
    
    var neatColorPicker = ChromaColorPicker()
    
    private var tapOutsideRecognizer: UITapGestureRecognizer!

        /**
     
     */
    override func viewDidLayoutSubviews() {
        neatColorPicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.neatColorPicker.stroke = 15
        self.neatColorPicker.hexLabel.isHidden = true
        self.neatColorPicker.shadeSlider.isHidden = true
    }
    
        @IBOutlet weak var colorPickerView: UIView!
        
        var transitioner = CAVTransitioner()

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
        
        open weak var delegate: ColorPickerViewControllerDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            colorPickerView.addSubview(neatColorPicker)
            // Do any additional setup after loading the view.
            
            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
//            mandalaImageView.addGestureRecognizer(tap)
        
        }
        

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

        if(self.tapOutsideRecognizer != nil) {
            self.view.window?.removeGestureRecognizer(self.tapOutsideRecognizer)
            self.tapOutsideRecognizer = nil
        }
    }

    func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Gesture methods to dismiss this with tap outside
    @objc func handleTapBehind(sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            let location: CGPoint = sender.location(in: self.view)

            if (!self.view.point(inside: location, with: nil)) {
                self.view.window?.removeGestureRecognizer(sender)
                self.close(sender: sender)
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        delegate?.colorPickerDidChooseColor(color)
        self.dismiss(animated: true, completion: nil)
    }
    
    }


