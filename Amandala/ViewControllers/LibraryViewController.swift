//
//  LibraryViewController.swift
//  Amandala
//
//  Created by Kseniia Shkurenko on 28.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit

/// Сontrol the screen of the library
class LibraryViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var chooseMandalaLable: UILabel! {
        didSet {
            chooseMandalaLable.text = Strings.chooseMandala
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 50)
    }



}
