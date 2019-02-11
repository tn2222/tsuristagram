//
//  ViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/08.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    @IBAction func tapGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

        let tabbar = MainTabBarViewController()
        self.present(tabbar, animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    

    
}

