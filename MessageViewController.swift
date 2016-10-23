//
//  MessageViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/20/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class MessageViewController: UIViewController {
    
    var message: MyMessage!
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageTopic: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        if let currname = self.message.sender {
            self.messageTitle.text = currname
        }
        if let currtopic = self.message.topic {
            self.messageTopic.text = currtopic
        }
        self.textView.text = self.message.content
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

