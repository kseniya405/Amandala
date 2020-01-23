//
//  UIView+makeCorners.swift
//  Amandala
//
//  Created by Денис Марков on 22.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit


public extension UIView {
   
  func makeAllCorners(){
    let path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
  }
   
  func makeCornersTop(){
    let path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
  }
   
  func makeCornersBottom(){
    let path = UIBezierPath(roundedRect:bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
  }
   
}
