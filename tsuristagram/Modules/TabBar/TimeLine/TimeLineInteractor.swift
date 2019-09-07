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

    var limit:UInt = 30
    // offsetの初期値は現在時間
    var offset: Int = (-1) * Int(Date().timeIntervalSince1970)
    var lastOffset: Int!

    var count: Int = 0
    var isFetching: Bool = false
    var isComplate: Bool = false

    func initialize() {
        FirebaseClient.observeToLast(id: "post", of: .childAdded, with: fetchLastOffset)
        FirebaseClient.observeSingleEvent(id: "users", key: CommonUtils.getUserId(), of: .value, with: fetchOwnUserDataComplate)
    }

    func fetchPostData() {
        count = 0
        FirebaseClient.observe(id: "post", limit: limit, offset: offset, of: .childAdded, with: fetchPostComplate)
    }
    
    func fetchUserData(userId: String) {
        FirebaseClient.observeSingleEvent(id: "users", key: userId, of: .value, with: fetchUserComplate)
    }
    
    func fetchPointData(pointId: String) {
        FirebaseClient.observeSingleEvent(id: "point", key: pointId, of: .value, with: fetchPointComplate)
    }
    
    func fetchLastOffset(snapshot: [String: AnyObject]) {
        if snapshot.count > 0 {
            self.lastOffset = Int(truncating: snapshot["timestamp"] as! NSNumber)
        }
        self.delegate?.interactor(self)
    }

    func fetchPostComplate(snapshot: [String: AnyObject]) {
        
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
            post.key = snapshot["key"] as! String

        }
        // setting next offset
        self.offset = Int(truncating: post.timestamp) + 1
        self.count += 1
        
        if self.lastOffset == Int(truncating: post.timestamp) {
            self.isFetching = false
            self.isComplate = true
        }
        if self.count == Int(self.limit) {
            self.isFetching = false
        }
        self.delegate?.interactor(self, post: post)
    }

    func fetchOwnUserDataComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        user.userName = snapshot["userName"] as! String
        let userBlock = snapshot["userBlock"] as! Dictionary<String, Bool>
        userBlock.forEach{ (key, value) in
            user.userBlock.append(key)
        }
        self.delegate?.interactor(self, own: user)
    }

    func fetchUserComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        user.userName = snapshot["userName"] as! String
        self.delegate?.interactor(self, user: user)
        self.delegate?.done(type: "users")
    }
    
    func fetchPointComplate(snapshot: [String:AnyObject]) {
        var point: Point = Point()
        point.id = snapshot["id"] as! String
        point.name = snapshot["name"] as! String
        point.latitude = snapshot["latitude"] as! Double
        point.longitude = snapshot["longitude"] as! Double
        self.delegate?.interactor(self, point: point)
        self.delegate?.done(type: "point")
    }

}
