//
//  ProgressChatViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class ProgressChatViewController: UITableViewController {
    
    let contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideWhenSwiped()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dismissNav" {
            let tOpReverse = TransitionOperator()
            tOpReverse.isPresenting = false
            segue.destinationViewController.transitioningDelegate = tOpReverse
            print((segue.destinationViewController.transitioningDelegate as? TransitionOperator)?.isPresenting)
        }
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension ProgressChatViewController {
    func hideWhenSwiped() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes() {
        performSegueWithIdentifier("dismissNav", sender: self)
    }
}
