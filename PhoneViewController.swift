//
//  PhoneViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class PhoneViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mynumber: UITextField!
    @IBOutlet weak var countryLab: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mynumber.delegate = self
        countryLab.delegate = self
        if let phoneNumber = NSUserDefaults.standardUserDefaults().valueForKey("phone") as? String {
            mynumber.text = phoneNumber
        }
        if let country = NSUserDefaults.standardUserDefaults().valueForKey("country") as? String {
            countryLab.text = country
        }
    }

    @IBAction func confirm(sender: AnyObject) {
        //save to persistent store
        self.view.endEditing(true)
        
        let number = mynumber.text
        let country = countryLab.text

        if number != nil && !number!.isEmpty {
            NSUserDefaults.standardUserDefaults().setValue(number, forKey: "phone")
        }
        
        if country != nil && !country!.isEmpty {
            NSUserDefaults.standardUserDefaults().setValue(country, forKey: "country")
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true;
    }
}

extension PhoneViewController {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    private func valid(phone: String) -> Bool { return true; }
}
