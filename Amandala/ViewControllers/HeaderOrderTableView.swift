//
//  HeaderOrderTableView.swift
//  Xeroe
//
//  Created by Денис Марков on 8/14/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import UIKit

class HeaderOrderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var namesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setParameters(sectionName: String) {
        self.namesLabel.text = sectionName
    }
}
