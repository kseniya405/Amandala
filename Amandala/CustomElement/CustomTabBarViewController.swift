//
//  CustomTabBarViewController.swift
//  Amandala
//
//  Created by Денис Марков on 31.01.2020.
//  Copyright © 2020 Kseniia Shkurenko. All rights reserved.
//

import UIKit


/// Standart TabBarController, but does not update the contents if the same ViewController that is selected now is selected
class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

}

//MARK: UITabBarControllerDelegate
extension CustomTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !(tabBarController.selectedViewController?.isEqual(viewController) ?? true)
    }
}
