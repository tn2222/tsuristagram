//
//  PointDetailInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PointDetailInteractor: PointDetailUsecase {
    
    // 取得処理の通知
    weak var delegate: PointDetailInteractorDelegate?

    func fetchData(pointId: String) {
        FirebaseClient.observe(id: "post", ordered: "pointId", value: pointId, of: .childAdded, with: fetchComplate)
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


}
