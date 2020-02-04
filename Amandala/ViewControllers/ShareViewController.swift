//
//  ShareViewController.swift
//  Amandala
//
//  Created by Денис Марков on 31.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var saveToGalleryButton: ButtonWithCornerRadius! {
        didSet {
            saveToGalleryButton.setParameters(text: "Save to gallery", font: UIFont(name: "Helvetica", size: 17), tintColor: .white, backgroundColor: Colors.coral)
            saveToGalleryButton.addTarget(self, action: #selector(saveToGalleryButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var backButton: UIButton!  {
           didSet {
               backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
           }
       }
    
    @IBOutlet weak var shareButton: ButtonWithCornerRadius! {
        didSet {
            shareButton.setParameters(text: "Share", font: UIFont(name: "Helvetica", size: 17), tintColor: .white, backgroundColor: Colors.coral)
           shareButton.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 2
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var savingImage: UIImage?
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.image = savingImage
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2

    }
    
    @objc func backButtonDidTap() {
        self.dismiss()
    }

    @objc func shareButtonDidTap() {
        if let image = imageView.image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    func setImage(image: UIImage?) {
        savingImage = image
    }
    
    @objc func saveToGalleryButtonDidTap() {
        guard let image = imageView.image else {
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIImageWriteToSavedPhotosAlbum(image,  self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {

           if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }

}

//MARK: UIScrollView Delegate
extension ShareViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
