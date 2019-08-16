//
//  PostDetailnteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class PostDetailInteractor: PostDetailUsecase {

    // 取得処理の通知
    weak var delegate: PostDetailInteractorDelegate?

    func fetchData(postKey: String) {
        FirebaseClient.observeSingleEvent(id: "post", key: postKey, of: .value, with: fetchPostComplate)
    }

    func fetchPoint(pointId: String) {
        FirebaseClient.observeSingleEvent(id: "point", key: pointId, of: .value, with: fetchPointComplate)
    }

    func fetchPostComplate(snapshot: [String:AnyObject]) {
        var post = Post()

        post.size = snapshot["size"] as! String
        post.weight = snapshot["weight"] as! String
        post.fishSpecies = snapshot["fishSpecies"] as! String
        post.timestamp = snapshot["timestamp"] as! NSNumber
        post.comment = snapshot["comment"] as! String
        post.fishingDate = snapshot["fishingDate"] as! String
        post.picture = snapshot["picture"] as! String
        post.pointId = snapshot["pointId"] as! String
        post.latitude = snapshot["latitude"] as! Double
        post.longitude = snapshot["longitude"] as! Double
        post.weather = snapshot["weather"] as! String

        self.delegate?.interactor(self, post: post)
    }

    func fetchPointComplate(snapshot: [String:AnyObject]) {
        var point = Point()
        point.latitude = snapshot["latitude"] as! Double
        point.longitude = snapshot["longitude"] as! Double
        point.name = snapshot["name"] as! String
        point.address = snapshot["address"] as! String
        self.delegate?.interactor(self, point: point)
    }
}
