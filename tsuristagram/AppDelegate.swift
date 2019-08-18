//
//  AppDelegate.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/08.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GoogleSignIn
import SVProgressHUD
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    let googleApiKey = AppKey().googleApiKey
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // navigation bar settings
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 17)!,.foregroundColor: UIColor.white]
        navBar.tintColor = UIColor.white
        navBar.barTintColor = UIColor(red: 69/255, green: 151/255, blue: 231/255, alpha: 1)
        
        
        
        // firebase initialize
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GMSServices.provideAPIKey(googleApiKey)
        
        //        let user = Auth.auth().currentUser
        //        if user != nil {
        //            print("Already logged in")
        //        } else {
        //            print("Not logged in")
        //        }
        
        return true
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
                    
                }else{
                    
                    print("user doesn't exist")
                    let currentTime = Int(Date().timeIntervalSince1970)
 UserExitRef.child("users").child(uid!).updateChildValues(["userId":uid!,"userPhoto":DefaltImageURL,"userName":"Unknown","timeStamp":Int(Date().timeIntervalSince1970), "updatedAt":Int(Date().timeIntervalSince1970)])
                    
                }
                self.userDefaults.set(uid, forKey: "userId")
                
            })
            SVProgressHUD.dismiss()
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}

