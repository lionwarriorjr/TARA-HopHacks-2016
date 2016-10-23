//
//  HelpTableViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/20/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class HelpTableViewController: StandardTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Can I chat with my doctor and nurses?" {
            let alertVC = UIAlertController(title: "Absolutely!",
                message: "To include your doctors or nurses in a message, start your message with @doc or include a provider's name in the message. With the best interests of you and other patients in mind we advise only queueing your doctor in when necessary, making it more likely for your doctor to respond to all patients in a more timely fashion.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Can my doctor see my chat history?" {
            let alertVC = UIAlertController(title: "Always",
                message: "Your doctor can and will always be able to review your chat history to better monitor your progress. Although your providers will likely not read every conversation with Tara, they will periodically review your chat history and be queued into messages sent directly to them.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Who is Tara?" {
            let alertVC = UIAlertController(title: "Hello!",
                message: "Tara is your personal medical assistant. We've designed her to respond to your questions, stay up-to-date on your treatment, answer your questions, communicate your progress, and be a mediator between you and your providers.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "Got it!", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Can I turn off notification alerts?" {
            let notificationsVC = self.storyboard?.instantiateViewControllerWithIdentifier("NotificationsVC")
                as! NotificationsViewController
            self.navigationController?.pushViewController(notificationsVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Can I schedule appointments within Tara Health?" {
            let alertVC = UIAlertController(title: "Yes, but only when necessary.",
                message: "You can request an appointment be scheduled from either your \"My Plan\" page, your Inbox (with a message to your provider), or by requesting Tara to schedule for you. We cannot confirm how quickly your providers will be able to accommodate.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "Understood", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "How is my data protected?" {
            let privacyVC = self.storyboard?.instantiateViewControllerWithIdentifier("StandardTableVC")
                as! StandardTableViewController
            privacyVC.sects = ["Tara Data Policy", "FDA and HIPAA Compliance, Data Coordination with Providers"]
            privacyVC.items = [["Data Policy","Terms of Service","Third Party Integration"], ["FDA Classification", "HIPAA Compliance",
                "HIPAA Security Rule","Integration With Your EHR"], ["Data Sharing with Providers","Health Insurance Provider Policy"]]
            self.navigationController?.pushViewController(privacyVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "About Tara" {
            let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("TextVC")
                as! TextViewController
            self.navigationController?.pushViewController(aboutVC, animated: true)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Staying In Touch With Your Providers" {
            let alertVC = UIAlertController(title: "Please keep your providers in the loop!",
                message: "You can stay in touch with your providers directly through your inbox and by sending messages directly to them through Tara.", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Group Conversations With Providers" {
            let alertVC = UIAlertController(title: "@doc",
                                            message: "Start your message with @doc or include a provider's name to include them in your conversations!", preferredStyle: .Alert)
            alertVC.addAction(UIAlertAction(title: "Got It!", style: .Cancel, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else if tableView.cellForRowAtIndexPath(indexPath)!.textLabel?.text ==
            "Contact Us With Questions" {
            let alertVC = UIAlertController(title: "What can we do for you?", message: "Please contact us at team@tara.com from your inbox with any questions about how we could improve your experience.", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
}
