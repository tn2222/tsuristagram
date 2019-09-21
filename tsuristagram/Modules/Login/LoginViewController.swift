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
import Crashlytics

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)

    }

    
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }

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
            
            self.showErrorIfNeeded(error)
            if error != nil{
                SVProgressHUD.dismiss()
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
                        dBRef.child("users").child(uid!).updateChildValues(["userId":uid!,"userPhoto":DefaltImageURL,"userName":"Unknown","timeStamp":Int(Date().timeIntervalSince1970), "updatedAt":Int(Date().timeIntervalSince1970),"userBlock":[]])
                        
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
            
            self.showErrorIfNeeded(error)
            if error != nil{
                SVProgressHUD.dismiss()
                return
            }

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
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
        
        let message = errorMessage(of: error) // エラーメッセージを取得
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func errorMessage(of error: Error) -> String {
        var message = "エラーが発生しました"
        guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
            return message
        }
        
        switch errcd {
        case .networkError: message = "ネットワークに接続できません"
        case .userNotFound: message = "ユーザが見つかりません"
        case .invalidEmail: message = "不正なメールアドレスです"
        case .emailAlreadyInUse: message = "このメールアドレスは既に使われています"
        case .wrongPassword: message = "入力した認証情報でサインインできません"
        case .userDisabled: message = "このアカウントは無効です"
        case .weakPassword: message = "パスワードが脆弱すぎます"
        // これは一例です。必要に応じて増減させてください
        default: break
        }
        return message
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

