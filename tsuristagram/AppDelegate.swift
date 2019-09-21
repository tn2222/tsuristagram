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
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
        
        let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType:"plist" )!)
        let storageBucket = "gs://" + (plist?.value(forKey: "STORAGE_BUCKET") as! String)
        self.userDefaults.set(storageBucket, forKey: "storageBucket")
        let databaseURL = plist?.value(forKey: "DATABASE_URL") as! String
        self.userDefaults.set(databaseURL, forKey: "databaseURL")

        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey(googleApiKey)
        
        // admob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Googleログイン
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Facebookログイン
        FBSDKApplicationDelegate.sharedInstance().application(application,didFinishLaunchingWithOptions: launchOptions)
        
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid
        
        if user != nil {
            print("ログインセッション継続中")
            
            self.userDefaults.set(uid, forKey: "userId")
            let viewController = MainTabBarViewController()
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
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

