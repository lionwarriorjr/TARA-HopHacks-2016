//
//  ContactsTableViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit
import Firebase

class ContactsTableViewController: UITableViewController {

    var ref = FIRDatabase.database().reference()
    
    //Populate the arrays using Firebase
    var contacts = [String]()
    var roles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if let user = FIRAuth.auth()?.currentUser {
            self.ref.child("contacts").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let contacts_array = snapshot.value! as! [[String: AnyObject]]
                for contact in contacts_array {
                    self.contacts.append(contact["name"] as! String)
                    self.roles.append(contact["role"] as! String)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorInParseAlert()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    func errorInParseAlert() {
        let alertVC = UIAlertController(title: "We're having trouble fetching your data.", message: "We appreciate your patience as we work on finding the best solution.", preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Contacts
        cell.person.text = contacts[indexPath.row]
        cell.providerRole.text = roles[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell;
    }
}
