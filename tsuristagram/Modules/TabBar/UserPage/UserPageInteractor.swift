//
//  UserPageInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class UserPageInteractor: UserPageUsecase {
    
    // 取得処理の通知
    weak var delegate: UserPageInteractorDelegate?

    func fetchUserData(userId: String) {
        FirebaseClient.observeSingleEvent(id: "users", key: userId, of: .value, with: fetchUserComplate)
    }

    func fetchUserComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        user.userName = snapshot["userName"] as! String
        self.delegate?.interactor(self, user: user)
    }

    func fetchData(userId: String) {
        FirebaseClient.observe(id: "post", ordered: "userId", value: userId, of: .childAdded, with: fetchComplate)
    }

    func report(reportType: Int, userId: String) {
        let feed = ["reporter" : CommonUtils.getUserId(),
                    "userId" : userId,
                    "type" : reportType,
                    "timeStamp":Int(Date().timeIntervalSince1970)
                    ] as [String:Any]
        
        FirebaseClient.setValue(id: "report", feed: feed, withCompletionBlock: self.reportComplate)

    }

    func reportComplate(error: Error?, ref: DatabaseReference) {
        // do nothing
    }

    func fetchComplate(snapshot: [String: AnyObject]) {
        
        var post = Post()
        
        if let userId = snapshot["userId"] as? String,
            let picture = snapshot["picture"] as? String {
            post.userId = userId
            post.picture = picture
            post.key = snapshot["key"] as! String
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
        }
        
        self.delegate?.interactor(self, post: post)
    }

    func userBlock(userId: String) {
        let feed = [userId:true] as [String:Any]
        
        FirebaseClient.userBlock(id: "users", value: CommonUtils.getUserId(), feed: feed, with: self.updateComplate)
    }

    func updateComplate(error: Error?, ref: DatabaseReference) {
        self.delegate?.interactor(self, error: error)
    }

}
