//
//  TabBarViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = tabColor
        let iconColor = UIColor(red: 0, green: 122/255.0, blue: 225/255.0, alpha: 1)
        UITabBar.appearance().tintColor = iconColor
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Avenir-Light", size: 10)!], forState: .Normal)
    }
}
