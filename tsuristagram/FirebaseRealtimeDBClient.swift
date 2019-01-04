//
//  FirebaseRealtimeDBClient.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/02.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import Firebase

class FirebaseRealtimeDBClient {
    let rootRef = Database.database().reference()

    func getTimeLineData() -> [Post] {

        var userName_Array = [String]()
        var date_Array = [String]()
        var picture_Array = [String]()
        var uid_Array = [String]()
        
        var posts = [Post]()

        rootRef.child("post").observe(.value) { (snap,error) in
            let postsSnap = snap.value as? [String:NSDictionary]
            
            if postsSnap == nil {
                return
            }
            var post = Post()
            for (_,postSnap) in postsSnap!{
                post = Post()
                
                if let uid = postSnap["USERUUID"] as? String, let userName = postSnap["userName"] as? String,let date = postSnap["date"] as? String,let picture = postSnap["picture"] as? String{
                    
                    post.uid = uid
                    post.userName = userName
                    post.date = date
                    post.picture = picture
                    
                    uid_Array.append(post.uid)
                    userName_Array.append(post.userName)
                    date_Array.append(post.date)
                    picture_Array.append(post.picture)
                }
            }
            posts.append(post)

        }
        return posts;
    }
}
