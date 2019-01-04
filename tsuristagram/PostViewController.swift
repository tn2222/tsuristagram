//
//  PostViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class PostViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var displayName = String()
    var pictureURLString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName = UserDefaults.standard.object(forKey: "displayName") as! String
        
        pictureURLString = UserDefaults.standard.object(forKey: "pictureURLString") as! String
        

        nameLabel.text = displayName
        profileImageView.sd_setImage(with: URL(string: pictureURLString), completed:nil)
        
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        
        
        
    }

    @IBAction func post(_ sender: Any) {
        
        let rootRef = Database.database().reference(fromURL: "https://tsuristagram.firebaseio.com/").child("post").childByAutoId()
        
        let feed = ["comment": textField.text,"userName":nameLabel.text] as [String:Any]
        rootRef.setValue(feed)

        textField.text = ""
        self.tabBarController!.selectedIndex = 0;


    }
    
}
