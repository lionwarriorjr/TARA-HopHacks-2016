//
//  ProfileViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var contents = ProfileViewController.populateSettings()
    var imgs = ProfileViewController.populateSettingsImg()
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser {
            self.ref.child("users").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let first = snapshot.value!["first"] as! String
                let last = snapshot.value!["last"] as! String
                dispatch_async(dispatch_get_main_queue()) {
                    self.profileName.hidden = false
                    self.profileName.text = first + " " + last
                    if (snapshot.value!["pickedImage"] as! Bool) {
                        let imageString = snapshot.value!["image"] as! String
                        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        let decodedImage = UIImage(data: decodedData!)!
                        self.profileImage.image = decodedImage
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.profileImage.image = UIImage(named: "signUpProfile")
                }
            }
        }
        
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")! as UITableViewCell
        
        cell.textLabel?.text = contents[indexPath.row]
        if indexPath.row < imgs.count {
            cell.imageView?.image = imgs[indexPath.row]
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Phone" {
            let phoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("PhoneVC")
                as! PhoneViewController
            self.presentViewController(phoneVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Notifications" {
            let notificationsVC = self.storyboard?.instantiateViewControllerWithIdentifier("NotificationsVC")
                    as! NotificationsViewController
                self.navigationController?.pushViewController(notificationsVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Payments" {
            let paymentsVC = self.storyboard?.instantiateViewControllerWithIdentifier("StandardTableVC")
                as! StandardTableViewController
            paymentsVC.sects = ["Payment Methods", "Payment History", "Security", "Support"]
            paymentsVC.items = [["Add New Debit Card", "Add New Credit Card", "Copayments"], ["Transactions"], ["PIN"],
                ["Help Center", "Contact Us"]]
            self.navigationController?.pushViewController(paymentsVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Privacy & Terms" {
            let privacyVC = self.storyboard?.instantiateViewControllerWithIdentifier("StandardTableVC")
                as! StandardTableViewController
            privacyVC.sects = ["Tara Health Data Policy", "FDA and HIPAA Compliance, Data Coordination with Providers"]
            privacyVC.items = [["Data Policy","Terms of Service","Third Party Integration"], ["FDA Classification", "HIPAA Compliance",
                "HIPAA Security Rule","Integration With Your EHR"], ["Data Sharing with Providers","Health Insurance Provider Policy"]]
            self.navigationController?.pushViewController(privacyVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Help" {
            let helpVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpTableVC")
                as! HelpTableViewController
            helpVC.sects = ["Frequently Asked Questions", "Browse Topics", "Contact Us"]
            helpVC.items = [["Can I chat with my doctor and nurses?", "Can my doctor see my chat history?", "Who is Tara?",
                "Can I turn off notification alerts?", "Can I schedule appointments within Tara Health?",
                "How is my data protected?"], ["About Tara Health","Staying In Touch With Your Providers",
                "Group Conversations With Providers"], ["Contact Us With Questions"]]
            self.navigationController?.pushViewController(helpVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Report a Problem" {
            let alertVC = UIAlertController(title: "What about your experience can be improved?", message: "Please let us know in a message to team@tara.com from your inbox.", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text
            == "Clear History" {
            let alertVC = UIAlertController(title: "Are you sure you want to clear your chat history?", message: "Once cleared, you can access your data again by requesting it be recovered through a message from your inbox to team@tara.com.", preferredStyle: .Alert)
            var alert_action = UIAlertAction(title: "Yes", style: .Default) {
                alert in
                do {
                    try (UIApplication.sharedApplication().delegate as! AppDelegate).stack.dropAllData()
                } catch { print("Could not erase your chat history. We appreciate your patience as we troubleshoot the problem.") }
            }
            alertVC.addAction(alert_action)
            alert_action = UIAlertAction(title: "No", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .Alert)
            var alert_action = UIAlertAction(title: "Log Out", style: .Default) {
                alert in
                do {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    try FIRAuth.auth()!.signOut()
                } catch {
                    print("Error in Log Out")
                }
            }
            alertVC.addAction(alert_action)
            alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private static func populateSettings() -> [String] {
        var contents = [String]()
        contents.appendContentsOf(["Phone","Notifications","Payments","Privacy & Terms",
            "Help","Report a Problem","Clear History","Log Out"])
        return contents;
    }
    
    private static func populateSettingsImg() -> [UIImage] {
        var imgs = [UIImage]()
        imgs.appendContentsOf([UIImage(named:"Phone")!,UIImage(named:"Notifications")!,UIImage(named: "Payments")!,UIImage(named: "Privacy")!,UIImage(named: "Help")!,UIImage(named: "Report")!])
        return imgs;
    }
    
    func dismiss() { self.dismissViewControllerAnimated(true, completion: updateProfile) }
    
    func updateProfile() { }
}
