//
//  LibraryViewController.swift
//  Amandala
//
//  Created by Kseniia Shkurenko on 28.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit


fileprivate let sectionName = [HeaderType.easy, HeaderType.medium, HeaderType.complex, HeaderType.special]
fileprivate let identifierTableViewCell = "LibraryTableViewCell"
fileprivate let identifierHeader = "HeaderOrderTableView"

/// Сontrol the screen of the library
class LibraryViewController: UIViewController {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var chooseMandalaLable: UILabel! {
        didSet {
            chooseMandalaLable.text = Strings.chooseMandala
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: identifierTableViewCell, bundle: nil), forCellReuseIdentifier: identifierTableViewCell)
        tableView.register(UINib.init(nibName: identifierHeader, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: identifierHeader)
    }
    
    override func viewDidLayoutSubviews() {
        topBarView.round(corners: [.bottomLeft, .bottomRight], radius: 30)
    }
    
}

// MARK: UITableViewDataSource
extension LibraryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierTableViewCell, for: indexPath) as! LibraryTableViewCell
        if indexPath.section < sectionName.count {
            let valueSection = HardcodedValuePictures(header: sectionName[indexPath.section])
            cell.setHeader(header: valueSection)
            cell.delegate = self
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width / 2.5 + 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}


// MARK: UITableViewDelegate
extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifierHeader) as! HeaderOrderTableView
        let valueSection = HardcodedValuePictures(header: sectionName[section])
        headerView.setParameters(sectionName: valueSection.header)
        
        return headerView
    }
}

// MARK: LibraryTableCellDelegate
extension LibraryViewController:  LibraryTableCellDelegate {
    
    func imageDidChange(image: UIImage?) {
        Routers().goToDrawingGallery(image: image, currentViewController: self)
    }
}

