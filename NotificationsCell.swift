//
//  NotificationsCell.swift
//  Medchat
//
//  Created by Srihari Mohan on 6/11/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    @IBOutlet weak var textLab: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func changed(sender: AnyObject) {
        print(textLab.text!)
        switch textLab.text! {
        case "Turn on Notifications":
            NSUserDefaults.standardUserDefaults().setValue(toggle.on, forKey: "switchNotifications")
        case "Sound":
            NSUserDefaults.standardUserDefaults().setValue(toggle.on, forKey: "switchSound")
        case "Vibrate":
            NSUserDefaults.standardUserDefaults().setValue(toggle.on, forKey: "switchVibrate")
        default: break
        }
    }
}
