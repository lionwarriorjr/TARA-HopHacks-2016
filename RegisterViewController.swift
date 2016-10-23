//
//  RegisterViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/22/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MobileCoreServices

class RegisterViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var card: UITextField!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var ehrSwitch: UISwitch!
    
    var ref = FIRDatabase.database().reference()
    
    var cameraPicker = UIImagePickerController()
    var imagePicker = UIImagePickerController()
    var defaultImage = true
    
    let MOBILE = 10
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(netHex: 0xeef2f3).CGColor, UIColor(netHex: 0xeef2f3).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        done.enabled = false
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0), NSFontAttributeName : UIFont(name: "Avenir Next", size: 16)!]
        cancel.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 11)!,NSForegroundColorAttributeName: UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)], forState: .Normal)
        cancel.action = #selector(RegisterViewController.dismiss)
        done.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 11)!], forState: .Normal)
        done.action = #selector(RegisterViewController.submit)
        navBar.translucent = false
        email.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        phone.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        card.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        ehrSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        email.layer.borderWidth = 1
        phone.layer.borderWidth = 1
        password.layer.borderWidth = 1
        first.layer.borderWidth = 1
        first.layer.borderColor = UIColor.grayColor().CGColor
        last.layer.borderWidth = 1
        last.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderWidth = 1
        email.layer.borderColor = UIColor.grayColor().CGColor
        phone.layer.borderColor = UIColor.grayColor().CGColor
        password.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderColor = UIColor.grayColor().CGColor
        card.delegate = self
        email.delegate = self
        phone.delegate = self
        password.delegate = self
        first.delegate = self
        last.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardHidden()
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardDidShow()
    }
    
    override func viewWillDisappear(animated: Bool) {
        email.resignFirstResponder()
        phone.resignFirstResponder()
        password.resignFirstResponder()
        first.resignFirstResponder()
        last.resignFirstResponder()
        card.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    func dismiss() { dismissViewControllerAnimated(true, completion: nil) }
    
    func submit() {
        //Firebase Authentification
        FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!) { (user, error) in
            
            if error == nil {
                
                print("creating user")
                
                /* TODO: ACCESS FROM PROVIDER SPECIFIC DATABASE = NOT HARDCODED */
                
                //Set User Profile
                self.ref.child("users").child(user!.uid).setValue(["phone": self.phone.text!])
                self.ref.child("users/" + "\(user!.uid)/" + "first").setValue(self.first.text!)
                self.ref.child("users/" + "\(user!.uid)/" + "last").setValue(self.last.text!)
                
                //Set Card Status (T/F) and then Card Number
                let card_status = self.card.text != nil && !self.card.text!.isEmpty
                if card_status {
                    self.ref.child("users/" + "\(user!.uid)/" + "card").setValue(NSString(string: self.card.text!))
                }
                self.ref.child("users/" + "\(user!.uid)/" + "card_status").setValue(card_status)
                
                //Set Plan Profile
                self.ref.child("plans/" + "\(user!.uid)/" + "provider").setValue("Bayview Medical Center")
                self.ref.child("plans/" + "\(user!.uid)/" + "treatment").setValue("Underactive Thyroid")
                self.ref.child("plans/" + "\(user!.uid)/" + "health_provider").setValue("Anthem Health Insurance")
                self.ref.child("plans/" + "\(user!.uid)/" + "diagnosis").setValue("Hypothyroidism")
                self.ref.child("plans/" + "\(user!.uid)/" + "contact").setValue("Dr. Elaine Cho, M.D.")
                self.ref.child("plans/" + "\(user!.uid)/" + "start_date").setValue("7/12/2016")
                self.ref.child("plans/" + "\(user!.uid)/" + "end_date").setValue("8/26/2016")
                self.ref.child("plans/" + "\(user!.uid)/" + "symptoms").setValue(["Fatigue",
                    "Cold Sensitivity", "High Cholesterol"])
                
                //Set Whether There Are Medications/Interventions for the Treatment Plan
                self.ref.child("plans/" + "\(user!.uid)/" + "medications").setValue(true)
                self.ref.child("plans/" + "\(user!.uid)/" + "interventions").setValue(true)
                
                //Set Interventions/Actions and Details
                self.ref.child("interventions").child(user!.uid).setValue(["actions": ["Treatment should begin at 50mg", "Dosage should reach max of 75mg after 5 weeks", "1 hour of cardiovascular exercise per day", "Meet once a week with your cognitive therapist Greg Weiss", "Gradually increase caloric intake once every 2 weeks"]])
                
                //Set Goal Details (goals == TRUE => details exist)
                let goalStatus = true //parse from doctor specific database to see if goal details entered at all
                self.ref.child("interventions/" + "\(user!.uid)/" + "goals").setValue(goalStatus)
                if goalStatus {
                    self.ref.child("goals/" + "\(user!.uid)/" + "goals").setValue([
                        "To reduce the size of your enlarged thyroid gland and restore production of your thyroid hormone, necessary to restore your hormonal balance.",
                        "To significantly boost thyroid hormone production and help ease your fatigue.",
                        "To regain your appetite and restore your heart rate to its natural rhythm.",
                        "To better cope with the irritability and mood swings you reported having recently. Your therapy will also help us better monitor your cognitive progress as the effects of your hypothyroidism wear off.",
                        "To quicken the treatment process by introducing a more nutritious diet back into your lifestyle."
                        ])
                    self.ref.child("goals/" + "\(user!.uid)/" + "goalDates").setValue(["5 weeks",
                        "2 months","Always","1.5 months","2 months"])
                }
                //Set Medications and Details
                self.ref.child("medications/" + "\(user!.uid)").setValue([
                    ["name": "Levothyroxine (Synthroid)", "amount": 50, "frequency": 1,
                    "description": "Take this capsule in the morning on an empty stomach. Wait at least 30 to 60 minutes before you eat any food. In the case you miss a dose, skip it and resume your regular dosing schedule. Do not take a double dose to make up for a missed one."],
                    ["name": "Daily Multivitamins", "amount": 10, "frequency": 2,
                    "description": "Take twice a day, once in the morning and once in the evening to help get your body its necessary nutrients and better absorb the benefits of your medication."
                    ]])
                
                //Set Provider Contacts
                self.ref.child("contacts").child(user!.uid).setValue([["name": "Dr. Elaine Cho", "role": "General Physician"],
                    ["name": "Sheryl Smith", "role": "Nurse Practitioner"], ["name": "Katherine Steiner", "role": "General Physician"], ["name": "Greg Weiss", "role": "Therapist"]])
                
                //Set Profile Image
                if !self.defaultImage {
                    let uploadImage = self.profileImage.image
                    let imageData = UIImagePNGRepresentation(uploadImage!)
                    let base64String: NSString = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                    self.ref.child("users/" + "\(user!.uid)/" + "pickedImage").setValue(true)
                    self.ref.child("users/" + "\(user!.uid)/" + "image").setValue(base64String)
                } else {
                    //Set That Profile Image Was Unselected
                    self.ref.child("users/" + "\(user!.uid)/" + "pickedImage").setValue(false)
                }
                
                //Set Data Screen: TODO = integrate data charts only relevant to patient
                //Progress Time Series By Default
                let barStatus = true //parse doctor specific database to count number of bar charts
                self.ref.child("data_snapshot/" + "\(user!.uid)/" + "groups/" + "baseChart").setValue(true)
                self.ref.child("data_snapshot/" + "\(user!.uid)/" + "groups/" + "progressTimeSeries").setValue(true)
                self.ref.child("data_snapshot/" + "\(user!.uid)/" + "groups/" + "bar").setValue(barStatus)
                self.ref.child("charts/" + "\(user!.uid)/" + "progressTimeSeries/" + "type").setValue("line")
                self.ref.child("charts/" + "\(user!.uid)/" + "bar/" + "type").setValue("bar")
                self.ref.child("charts/" + "\(user!.uid)/" + "progressTimeSeries/" + "units").setValue("Treatment Progress in %")
                self.ref.child("charts/" + "\(user!.uid)/" + "bar/" + "units").setValue(["Therapy Sessions"])
                //Set data
                self.ref.child("baseChart/" + "\(user!.uid)/" + "x").setValue(["Thyroid", "Fatigue", "Joint Pain", "Depression", "Cardiovascular"])
                self.ref.child("baseChart/" + "\(user!.uid)/" + "y").setValue([40,30,15,35,30])
                self.ref.child("progressTimeSeries/" + "\(user!.uid)/" + "x").setValue(["Day: 0","1","2","3","4","5"])
                self.ref.child("progressTimeSeries/" + "\(user!.uid)/" + "y").setValue([0,18,20,15,35,35])
                self.ref.child("bar/" + "\(user!.uid)/" + "x").setValue([["Week: 1","2","3","4"]])
                self.ref.child("bar/" + "\(user!.uid)/" + "y").setValue([[3,2,4,1]])
                
            } else { //Alert Message in Case of Registration Error
                dispatch_async(dispatch_get_main_queue()) {
                    let alertVC = UIAlertController(title: "Your providers have not yet approved this account registration.", message: "We suggest reaching out to them as soon as possible to mitigate the delay.", preferredStyle: .Alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertVC, animated: true, completion: nil)
                }
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func scanFromCamera(sender: AnyObject) {
    }
    
    @IBAction func scanFromLabel(sender: AnyObject) {
    }
    
    @IBAction func editProfilePic(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Edit Picture", message: "", preferredStyle: .ActionSheet)
        alertVC.addAction(UIAlertAction(title: "Choose From Library", style: .Default, handler: choosePhoto))
        alertVC.addAction(UIAlertAction(title: "Remove Picture", style: .Default, handler: removePicture))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func takePhoto(_: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                let cameraDelegate = CameraDelegate()
                cameraPicker.allowsEditing = false
                cameraPicker.sourceType = .Camera
                cameraPicker.mediaTypes = [kUTTypeImage as String]
                cameraPicker.cameraCaptureMode = .Photo
                cameraPicker.delegate = cameraDelegate
                self.presentViewController(cameraPicker, animated: true, completion: nil)
            }
        } else {
            print("Camera inaccessible")
        }
    }
    
    func choosePhoto(_: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func removePicture(_: UIAlertAction) {
        self.profileImage.image = nil
        defaultImage = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImage.image = nil
        profileImage.image = image
        defaultImage = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RegisterViewController {
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            if !text.isEmpty {
                if textField == self.email {
                    //verify email
                    print("email checked")
                } else if textField == self.phone {
                    //verify phone
                    if text.characters.count == MOBILE {
                        let number = "(" + text.substringToIndex(text.startIndex.advancedBy(3)) + ") " +
                            text.substringWithRange(text.startIndex.advancedBy(3) ..<
                            text.endIndex.advancedBy(-4)) + "-" + text.substringFromIndex(text.endIndex.advancedBy(-4))
                        textField.text = number
                        print("mobile checked")
                    } else {
                        let alertVC = UIAlertController(title: "Invalid Phone Number", message: "", preferredStyle: .Alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
        done.enabled = (!(email.text?.isEmpty)! && !(phone.text?.isEmpty)! &&
            !(password.text?.isEmpty)! && !(first.text?.isEmpty)! && !(last.text?.isEmpty)!)
        print("done enabled/disabled")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if email.editing {
            phone.becomeFirstResponder()
        } else if phone.editing {
            password.becomeFirstResponder()
        } else if password.editing {
            first.becomeFirstResponder()
        } else if first.editing {
            last.becomeFirstResponder()
        } else if last.editing {
            card.becomeFirstResponder()
        } else if card.editing {
            self.resignFirstResponder()
        }
        return true;
    }

    func keyboardWillShow(notification: NSNotification) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if card.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardDidShow(notification: NSNotification) {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    func keyboardWillHide(notification: NSNotification) {
        if card.editing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    func subscribeToKeyboardHidden() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
    }

    func subscribeToKeyboardDidShow() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardDidShow() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardHidden() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.resignFirstResponder()
        view.endEditing(true)
    }
}
