//
//  ViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/08.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController ,LineSDKLoginDelegate {

    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LineSDKLogin.sharedInstance().delegate = self
    }

    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        
        if let displayName = profile?.displayName {
            self.displayName = displayName
        }
        
        if let pictureURL = profile?.pictureURL {
            self.pictureURLString = pictureURL.absoluteString
        }
        
        UserDefaults.standard.set(self.displayName, forKey: "displayName")
        UserDefaults.standard.set(self.pictureURLString, forKey: "pictureURLString")

        performSegue(withIdentifier: "next", sender: nil)
    }
    
    
    @IBAction func login(_ sender: Any) {
        LineSDKLogin.sharedInstance().start()
    }
    
}

