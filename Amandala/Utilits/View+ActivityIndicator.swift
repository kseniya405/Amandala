//
//  View+ActivityIndicator.swift
//  Amandala
//
//  Created by Kseniia Shkurenkoon 14.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // launch Activity Indicator
    func showActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        //location
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 80, height: 80);
        activityIndicator.center = self.center
        
        // style
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        }
        activityIndicator.color = Colors.coral
        activityIndicator.hidesWhenStopped = true
        
        // add and start
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    func stopActivityIndicator(activityIndicator: UIActivityIndicatorView) -> Void {
        activityIndicator.stopAnimating()
    }
}
