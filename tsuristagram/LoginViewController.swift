//
//  ViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/08.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftVideoBackground
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        try? VideoBackground.shared.play(view: view, videoName: "nc92133", videoType: "mp4", willLoopVideo: true)

    }

    @IBAction func tapGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        performSegue(withIdentifier: "next", sender: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    

    
}

