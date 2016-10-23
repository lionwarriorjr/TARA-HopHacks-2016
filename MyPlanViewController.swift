//
//  MyPlanViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/21/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit
import Firebase

class MyPlanViewController: UIViewController, UINavigationControllerDelegate,
    UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var medsTableView: UITableView!
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet var contacts: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var treatmentLab: UILabel!
    @IBOutlet weak var insurer: UILabel!
    @IBOutlet weak var diagnosisLab: UILabel!
    @IBOutlet weak var doctorLab: UILabel!
    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var symptomsLab: UILabel!
    
    var ref = FIRDatabase.database().reference()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //Arrays Populated Through Firebase
    var meds = [String]()
    var doses = [Double]()
    var freq = [Int]()
    var treatments = [String]()
    var instructions = [String]()
    var goals = [String]()
    var goalDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        contacts.target = self.revealViewController()
        contacts.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        medsTableView.tableFooterView = UIView()
        planTableView.tableFooterView = UIView()
        medsTableView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        planTableView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0), NSFontAttributeName : UIFont(name: "GillSans-UltraBold", size: 16)!]
        
        if let user = FIRAuth.auth()?.currentUser {
            
            self.ref.child("plans").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let contact = snapshot.value!["contact"] as! String
                let diagnosis = snapshot.value!["diagnosis"] as! String
                let start_date = snapshot.value!["start_date"] as! String
                let end_date = snapshot.value!["end_date"] as! String
                let health_provider = snapshot.value!["health_provider"] as! String
                let provider = snapshot.value!["provider"] as! String
                let treatment = snapshot.value!["treatment"] as! String
                let symptoms = snapshot.value!["symptoms"] as! [String]
                dispatch_async(dispatch_get_main_queue()) {
                    self.provider.text = provider
                    self.doctorLab.text = contact
                    self.startLab.text = start_date
                    self.endLab.text = end_date
                    self.insurer.text = health_provider
                    self.treatmentLab.text = treatment
                    self.symptomsLab.text = symptoms.joinWithSeparator(", ")
                    self.diagnosisLab.text = diagnosis
                    self.unhide()
                }
            }) { (error) in
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorInParseAlert()
                }
            }
            
            self.ref.child("interventions").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let actions = snapshot.value!["actions"] as! [String]
                self.treatments = actions
            }) { (error) in
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                   self.errorInParseAlert()
                }
            }
            
            self.ref.child("medications").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                // Get user value
                let prescriptions = snapshot.value! as! [[String: AnyObject]]
                
                for dictionary in prescriptions {
                    self.doses.append(dictionary["amount"] as! Double)
                    self.freq.append(dictionary["frequency"] as! Int)
                    self.meds.append(dictionary["name"] as! String)
                    self.instructions.append(dictionary["description"] as! String)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.medsTableView.reloadData()
                    self.planTableView.reloadData()
                }
                
            }) { (error) in
                print(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorInParseAlert()
                }
            }
            
            self.ref.child("goals").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                self.goals = snapshot.value!["goals"] as! [String]
                self.goalDates = snapshot.value!["goalDates"] as! [String]
                dispatch_async(dispatch_get_main_queue()) {
                    self.planTableView.reloadData()
                }
            }) { (error) in }
        }
    }
    
    func unhide() {
        self.provider.hidden = false
        self.doctorLab.hidden = false
        self.startLab.hidden = false
        self.endLab.hidden = false
        self.insurer.hidden = false
        self.symptomsLab.hidden = false
        self.diagnosisLab.hidden = false
        self.treatmentLab.hidden = false
    }
    
    func errorInParseAlert() {
        let alertVC = UIAlertController(title: "We're having trouble fetching your data.", message: "We appreciate your patience as we work on finding the best solution.", preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.delegate = nil
    }
}

extension MyPlanViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(medsTableView) {
            return meds.count;
        } else {
            return treatments.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(medsTableView) {
            let medCell = tableView.dequeueReusableCellWithIdentifier("medsCell")
                as! MedsTableViewCell
            medCell.medType.text = meds[indexPath.row]
            medCell.doseLab.text = "\(doses[indexPath.row])mg"
            medCell.freqLab.text = "\(freq[indexPath.row])x day"
            return medCell;
        } else {
            let planCell = tableView.dequeueReusableCellWithIdentifier("treatmentCell")
                    as! TreatmentTableViewCell
            planCell.intervention.text = "\(indexPath.row+1). \(treatments[indexPath.row])"
            return planCell;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(medsTableView) {
            let medAlertVC = UIAlertController(title: "\(meds[indexPath.row])", message: "\(instructions[indexPath.row])", preferredStyle: .Alert)
            medAlertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(medAlertVC, animated: true, completion: nil)
        } else {
            let goalsAlertVC = UIAlertController(title: "Goal (\(goalDates[indexPath.row]))", message: "\(goals[indexPath.row])", preferredStyle: .Alert)
            goalsAlertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(goalsAlertVC, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
