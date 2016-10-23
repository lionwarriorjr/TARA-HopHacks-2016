//
//  LoginViewController.swift
//  Medchat
//
//  Created by Srihari Mohan on 10/22/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVKit
import AVFoundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var taraView: UIView!
    @IBOutlet weak var taraLabel: UILabel!
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    @IBAction func signupuser(sender: AnyObject) {
        print("signup")
        //present modally
        let registerVC = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterVC") as! RegisterViewController
        self.presentViewController(registerVC, animated: true, completion: nil)
    }
    
    @IBAction func loginuser(sender: AnyObject) {
        print("signin")
        let signinVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignInVC") as!
            SignInViewController
        self.navigationController?.pushViewController(signinVC, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        player.seekToTime(kCMTimeZero)
        player.play()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 4
        registerButton.layer.cornerRadius = 4
        signInButton.clipsToBounds = true
        signInButton.layer.masksToBounds = false
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor(netHex: 0x2196F3).CGColor
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        self.view.addMotionEffect(group)
        let path = NSBundle.mainBundle().pathForResource("TaraVidV5", ofType: "mp4")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVPlayer(URL: fileURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.playerItemDidReachEnd(_:)), name: "continueVideo", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.playerItemDidReachEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        self.view.layer.addSublayer(playerLayer)
        self.view.bringSubviewToFront(signInButton)
        self.view.bringSubviewToFront(registerButton)
        self.view.bringSubviewToFront(taraView)
        self.view.bringSubviewToFront(taraLabel)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seekToTime(kCMTimeZero)
        player.play()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("continueVideo", object: nil)
    }
    
    @IBAction func verify(sender: AnyObject) {
        let signinVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignInVC") as!
        SignInViewController
        self.navigationController?.pushViewController(signinVC, animated: false)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
