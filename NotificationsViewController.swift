//
//  NotificationsViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class NotificationsViewController: UITableViewController {

    let sects = ["Turn on notifications to get messages faster, even when you're not using the app", "Adjust sound and vibration settings for Medchat notifications you get when you're using the app"]
    let items = [["Turn on Notifications"], ["Sound", "Vibrate"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sects.count;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sects[section].lowercaseString;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items[section].count;
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text = sects[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationsCell
        cell.textLab.text = items[indexPath.section][indexPath.row]
        
        if cell.textLab.text! == "Turn on Notifications" {
            print("Entered Notifications")
            if let statusNotify = NSUserDefaults.standardUserDefaults().valueForKey("switchNotifications") as? Bool {
                cell.toggle.on = statusNotify
            }
        } else if cell.textLab.text! == "Sound" {
            print("Entered Sound")
            if let statusSound = NSUserDefaults.standardUserDefaults().valueForKey("switchSound") as? Bool {
                cell.toggle.on = statusSound
            }
        } else {
            if let statusVibrate = NSUserDefaults.standardUserDefaults().valueForKey("switchVibrate") as? Bool {
                cell.toggle.on = statusVibrate
            }
        }

        return cell;
    }
}
