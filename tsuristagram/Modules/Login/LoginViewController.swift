//
//  ViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/08.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase
import FacebookLogin
import SVProgressHUD

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    @IBAction func tapGoogleSignIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        //let tabbar = MainTabBarViewController()
        //self.present(tabbar, animated: true, completion: nil)
    }
    
    @IBAction func tapFbSignIn(_ sender: Any) {
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.email], viewController: nil, completion:
            {result in
                
                switch result {
                    
                case let .success( permission, declinePemisson, token):
                    
                    SVProgressHUD.show()
                    
                    print("token:\(token),\(permission),\(declinePemisson)")
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                    
                    SVProgressHUD.dismiss()
                    
                    self.signIn(credential: credential)
                    
                case let .failed(error):
                    print("error:\(error)")
                    
                    SVProgressHUD.dismiss()
                    
                case .cancelled:
                    print("cancelled")
                    SVProgressHUD.dismiss()
                }
        })

    }

    ///Facebook///////////////////////////////////////////////////////////////////////////
    func signIn(credential: AuthCredential){
        
        SVProgressHUD.show()
        
        let dBRef = Database.database().reference()
        let DefaltImageURL = "https://firebasestorage.googleapis.com/v0/b/tsuristagram.appspot.com/o/DefaultUserImage.png?alt=media&token=8268adf5-7ad7-466d-abed-778d8819df4a"
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                
                print("error:\(error)")
                return
                
            } else {
                
                dBRef.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let uid = user?.user.uid
                    
                    if snapshot.hasChild(uid!){
                        
                        print("user exist")
                        
                        SVProgressHUD.dismiss()
                        print("Facebook Signed In")
                        
                        let tabbar = MainTabBarViewController()
                        self.present(tabbar, animated: true, completion: nil)
                        
                    }else{
                        
                        print("user doesn't exist")
                        
                        let currentTime = Int(Date().timeIntervalSince1970)
                        dBRef.child("users").child(uid!).updateChildValues(["userId":uid!,"userPhoto":DefaltImageURL,"userName":"Unknown","timeStamp":Int(Date().timeIntervalSince1970), "updatedAt":Int(Date().timeIntervalSince1970)])
                        
                        let tabbar = MainTabBarViewController()
                        self.present(tabbar, animated: true, completion: nil)
                        
                        SVProgressHUD.dismiss()
                        
                    }
                    self.userDefaults.set(uid, forKey: "userId")
                })
            }
            return
        }
    }


    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
            print(error.localizedDescription)
            return
        }

        SVProgressHUD.show()

        let authentication = user.authentication
        // get firebase credential
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                       accessToken: (authentication?.accessToken)!)

        let UserExitRef = Database.database().reference()
        let DefaltImageURL = "https://firebasestorage.googleapis.com/v0/b/tsuristagram.appspot.com/o/DefaultUserImage.png?alt=media&token=8268adf5-7ad7-466d-abed-778d8819df4a"
        Auth.auth().signIn(with: credential) { (user, error) in

            print("Sign on Firebase successfully")
            print("Google Signed In")
            UserExitRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in

                let uid = user?.user.uid
                //let photoURL = user?.photoURL
                //let name = user?.displayName

                if snapshot.hasChild(uid!){

                    print("user exist")

                    let tabbar = MainTabBarViewController()
                    self.present(tabbar, animated: true, completion: nil)
                    
                }else{

                    print("user doesn't exist")
                    let currentTime = Int(Date().timeIntervalSince1970)
                    UserExitRef.child("users").child(uid!).updateChildValues(["userId":uid!,"userPhoto":DefaltImageURL,"userName":"Unknown","timeStamp":Int(Date().timeIntervalSince1970), "updatedAt":Int(Date().timeIntervalSince1970)])
                    
                    let tabbar = MainTabBarViewController()
                    self.present(tabbar, animated: true, completion: nil)

                }
                self.userDefaults.set(uid, forKey: "userId")
            })
            SVProgressHUD.dismiss()
        }
    }
    
    //Googleログイン
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("disconnects Google Login")
    }
    ///Google///////////////////////////////////////////////////////////////////////////


    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    

    
}

