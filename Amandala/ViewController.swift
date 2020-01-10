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

class ViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mandalaImage: FloodImage!
    
    override func viewDidAppear(_ animated: Bool) {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = SVGKImage(named: "3.svg").uiImage
        mandalaImage.originImage = image
        mandalaImage.contentMode = .scaleAspectFill
        mandalaImage.isUserInteractionEnabled = true
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.navigationController?.toolbar.tintColor = Colors.coral
//        self.navigationItem.title = Strings.chooseMandala
//
//        // add a tap recognizer to the image view
//        let tap = UITapGestureRecognizer(target: self,
//                     action: #selector(self.tapGesture(_:)))
//        mandalaImage.addGestureRecognizer(tap)
//        mandalaImage.isUserInteractionEnabled = true
//
//
//        if let image =  SVGKImage(named: "1.svg"), let svgImageView = SVGKFastImageView(svgkImage: image) {
//                svgImageView.frame = mandalaImage.frame
//            mandalaImage.contentMode = .scaleToFill
//            self.mandalaImage.image = svgImageView.image.uiImage
//            if let imagePNG = svgImageView.image.uiImage{
//                DispatchQueue.main.async {
//                    self.mandalaImage.image = imagePNG.pbk_imageByReplacingColorAt(0, 0, withColor: .blue, tolerance: 0)
//                }
//            }
//            mandalaImage.originImage = self.mandalaImage.image
//            mandalaImage.originImage = UIImage(named: "Hexagon")
//            mandalaImage.isUserInteractionEnabled = true
//        } else {
//            print("Incorrect image")
//        }
//    }


//    var img: CGImage?
//
//
//    func convertTapToImg(_ point: CGPoint) -> CGPoint? {
//        img = mandalaImage.image?.cgImage
//        let imgView = mandalaImage
//
//        let xRatio = imgView!.frame.width / CGFloat(img!.width)
//        let yRatio = imgView!.frame.height / CGFloat(img!.height)
//        print("imgView!.frame.width \(imgView!.frame.width) / img!.size.width \(img!.width) " , " imgView!.frame.height  \(imgView!.frame.height) / img!.size.height \(img!.height ) ")
//        let ratio = min(xRatio, yRatio)
//
//        let imgWidth = CGFloat(img!.width) * ratio
//        let imgHeight = CGFloat(img!.height) * ratio
//
//        var tap = point
//        var borderWidth: CGFloat = 0
//        var borderHeight: CGFloat = 0
//        // detect border
//        if ratio == yRatio {
//            // border is left and right
//            borderWidth = (imgView!.frame.size.width - imgWidth) / 2
//            if point.x < borderWidth || point.x > borderWidth + imgWidth {
//                return nil
//            }
//            tap.x -= borderWidth
//        } else {
//            // border is top and bottom
//            borderHeight = (imgView!.frame.size.height - imgHeight) / 2
//            if point.y < borderHeight || point.y > borderHeight + imgHeight {
//                return nil
//            }
//            tap.y -= borderHeight
//        }
//
//        let xScale = tap.x / (imgView!.frame.width - 2 * borderWidth)
//        let yScale = tap.y / (imgView!.frame.height - 2 * borderHeight)
//        let pixelX = CGFloat(img!.width) * xScale
//        let pixelY = CGFloat(img!.height) * yScale
//        return CGPoint(x: pixelX, y: pixelY)
//    }
//
//    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
//        let point = gesture.location(in: mandalaImage)
//        let imgPoint = convertTapToImg(point)
//        print("tap: \(point) -> img \(String(describing: imgPoint))")
//        DispatchQueue.main.async {
//            self.mandalaImage.image = self.mandalaImage.image?.pbk_imageByReplacingColorAt(Int(imgPoint!.x), Int(imgPoint!.y), withColor: .blue, tolerance: 1, antialias: true)
//        }
//    }
}

