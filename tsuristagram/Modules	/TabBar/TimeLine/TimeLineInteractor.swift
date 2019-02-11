//
//  TimeLineInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class TimeLineInteractor: TimeLineUsecase {
    // 取得処理の通知
    weak var delegate: TimeLineInteractorDelegate?

    let limit:UInt = 3
    var offset = NSNumber(value: 0)
    var fetchFlag = false
    func fetchPostData() {
        if !fetchFlag {
            print("fetching... ")
            fetchFlag = true
            FirebaseClient.observeSingleEvent(id: "post", limit: limit, offset: "", of: .childAdded, with: fetchPostComplate)
        }
    }
    
    func fetchUserData() {
        FirebaseClient.observeSingleEvent(id: "users", of: .value, with: fetchUserComplate)
    }
    
    func fetchPointData() {
        FirebaseClient.observeSingleEvent(id: "point", of: .value, with: fetchPointComplate)
    }

    func fetchPostComplate(snapshot: [String: AnyObject]) {
//        self.offset = snapshot.count + 1 as NSNumber
        
        var postList = [Post]()
//        for (_,snap) in snapshot {
        var post = Post()
            
        if let userId = snapshot["userId"] as? String,
            let picture = snapshot["picture"] as? String {
                
            post.userId = userId
            post.picture = picture
            post.size = snapshot["size"] as! String
            post.weight = snapshot["weight"] as! String
            post.fishSpecies = snapshot["fishSpecies"] as! String
            post.comment = snapshot["comment"] as! String
            post.fishingDate = snapshot["fishingDate"] as! String
            post.timestamp = snapshot["timestamp"] as! NSNumber
            post.pointId = snapshot["pointId"] as! String
            post.latitude = snapshot["latitude"] as! Double
            post.longitude = snapshot["longitude"] as! Double
            post.weather = snapshot["weather"] as! String
            
//                postList.append(post)
            }
//        }
        self.delegate?.interactor(self, postList: postList)
    }

    func fetchUserComplate(snapshot: [String:NSDictionary]) {
        self.delegate?.interactor(self, userMap: snapshot)
        self.delegate?.done()
        fetchFlag = false
    }
    
    func fetchPointComplate(snapshot: [String:NSDictionary]) {
        self.delegate?.interactor(self, pointMap: snapshot)
        self.delegate?.done()
    }

}
