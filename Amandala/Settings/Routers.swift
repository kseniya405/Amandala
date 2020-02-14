//
//  Routers.swift
//  Amandala
//
//  Created by Денис Марков on 14.02.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import Foundation

class Routers {
    func goToDrawingGallery(image: UIImage?, currentViewController: UIViewController) {
        guard let chooseImage = image else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "DrawingAreaViewController") as! DrawingAreaViewController
        initialViewController.setImage(image: chooseImage)
        currentViewController.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    func goToShareScreen(image: UIImage?, cv: UIViewController) {
        guard let chooseImage = image else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        initialViewController.setImage(image: chooseImage)
        cv.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    func goToLibraryScreen(vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! CustomTabBarViewController
        initialViewController.selectedIndex = 1
        vc.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    func goToGalleryScreen(vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! CustomTabBarViewController
        initialViewController.selectedIndex = 0
        vc.navigationController?.pushViewController(initialViewController, animated: true)
    }
}
