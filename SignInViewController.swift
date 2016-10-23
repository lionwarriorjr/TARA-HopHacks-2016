//
//  SignInViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/22/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardShown = Bool()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.colors = [UIColor(netHex: 0x00d2ff).CGColor, UIColor(netHex: 0x928DAB).CGColor]
//        self.view.layer.insertSublayer(gradient, atIndex: 0)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(red: 0/255.0, green: 142/255.0, blue: 204/255.0, alpha: 1.0).CGColor, UIColor(netHex: 0x2196f3).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0), NSFontAttributeName : UIFont(name: "Avenir Next", size: 16)!]
        email.delegate = self
        password.delegate = self
        email.backgroundColor = UIColor.whiteColor()
        password.backgroundColor = UIColor.whiteColor()
        email.borderStyle = .None
        password.borderStyle = .None
        email.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        email.attributedPlaceholder = NSAttributedString(string: "Email",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        password.attributedPlaceholder = NSAttributedString(string: "Password",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        signin.layer.borderWidth = 1.0
        signin.layer.borderColor = UIColor.whiteColor().CGColor
        cancel.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 11)!,NSForegroundColorAttributeName: UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)], forState: .Normal)
        cancel.action = #selector(SignInViewController.dismiss)
        signin.addTarget(self, action: #selector(SignInViewController.login), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        email.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func login() {
        if let eText = email.text, pText = password.text {
            self.authenticate(eText, password: pText)
        }
    }
    
    func dismiss() { self.navigationController?.popViewControllerAnimated(false) }
}

extension SignInViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.resignFirstResponder()
        view.endEditing(true)
    }
}

extension SignInViewController {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.password {
            textField.resignFirstResponder()
            if let eText = email.text, pText = password.text {
                self.authenticate(eText, password: pText)
            }
        } else {
            self.password.becomeFirstResponder()
        }
        return true;
    }
    
    func authenticate(username: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(username, password: password) { (user, error) in
            if error == nil {
                //configure user settings
                print("Signing In")
                
                self.performSegueWithIdentifier("authenticate", sender: self)
            } else {
                let alertVC = UIAlertController(title: "Could Not Sign In", message: "Invalid username or password", preferredStyle: .Alert)
                let alert_action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertVC.addAction(alert_action)
                self.presentViewController(alertVC, animated: true, completion: nil)
            }
        }
    }
}