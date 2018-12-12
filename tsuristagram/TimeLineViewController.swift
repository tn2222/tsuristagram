//
//  TimeLineViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import Firebase

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var displayName = String()
    var comment = String()
    
    let refreshControl = UIRefreshControl()
    
    var userName_Array = [String]()
    var comment_Array = [String]()
    
    var posts = [Post]()
    var post = Post()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        userNameLabel.text = self.posts[indexPath.row].userName

        
        let commentLabel = cell.viewWithTag(2) as! UILabel
        commentLabel.text = self.posts[indexPath.row].comment
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    @objc func refresh(){
        fetchData()
        refreshControl.endRefreshing()
    }
    
    func fetchData(){
        self.post = Post()
        self.userName_Array = [String]()
        self.comment_Array = [String]()

        let ref = Database.database().reference()
        ref.child("post").observeSingleEvent(of: .value) { (snap,error) in
            
            let postsSnap = snap.value as? [String:NSDictionary]
            
            if postsSnap == nil {
                return
            }
            self.posts = [Post]()

            for (_,post) in postsSnap!{
                
                self.post = Post()
                
                if let comment = post["comment"] as? String, let userName = post["userName"] as? String {
                    
                    self.post.comment = comment
                    self.post.userName = userName

                    self.comment_Array.append(self.post.comment)
                    self.userName_Array.append(self.post.userName)
                    
                    
                }
                
                self.posts.append(self.post)
                
            }
            
            self.tableView.reloadData()
        }
    }
}
