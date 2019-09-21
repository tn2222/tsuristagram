//
//  PostInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/04.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class PostInteractor: PostUsecase {
    // 取得処理の通知
    weak var delegate: PostInteractorDelegate?
    
    var latitude: Double!
    var longitude: Double!
    
    func fetchPointData(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        FirebaseClient.observeSingleEvent(id: "point", of: .value, with: fetchComplate)
    }
 
    func fetchComplate(snapshot: [String:NSDictionary]) {
        var pointList = [Point]()
        for (id,snap) in snapshot {
            var point: Point = Point()
            if let latitude = snap["latitude"] as? Double,
                let longitude = snap["longitude"] as? Double,
                let name = snap["name"] as? String,
                let address = snap["address"] as? String {
                point.id = id
                point.latitude = latitude
                point.longitude = longitude
                point.name = name
                point.address = address
                
                if self.latitude == 0 && self.longitude == 0 {
                    point.distance = 99999
                    point.positionGetFlag = false
                } else {
                    point.distance = CommonUtils.distance(current: (la: self.latitude, lo: self.longitude), target: (la: latitude, lo: longitude))
                    point.positionGetFlag = true
                }
            }
            pointList.append(point)
        }
        self.delegate?.interactor(self, pointList: pointList)
    }
    
    func postButton(post: Post) {
        let currentTime = Int(Date().timeIntervalSince1970)
        
        // Firebaseの昇順でしかソートできないため、ソートキー項目をマイナス値にしておく
        let timestamp: NSNumber = NSNumber(value:(-1) * currentTime)
        
        let myUid = CommonUtils.getUserId()
        let storageBucket = CommonUtils.getStorageBucket()

        let photoImageRef = Storage.storage().reference(forURL: storageBucket).child("images").child(myUid).child("post").child(String(currentTime) + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let photoImageUploadData = post.uploadPhotoImage.jpegData(compressionQuality: 0.1)
        
        // FireStoreへアップロード
        let uploadTask = photoImageRef.putData(photoImageUploadData!, metadata: metadata) { (metadata, err) in
            guard let metadata = metadata else { return }
            photoImageRef.downloadURL { (url, err) in
                guard let url = url else { return }
                
                let feed = ["size": post.size,
                            "weight": post.weight,
                            "fishSpecies": post.fishSpecies,
                            "comment": post.comment,
                            "fishingDate": post.fishingDate,
                            "picture": url.absoluteString,
                            "pointId": post.pointId,
                            "latitude": post.latitude,
                            "longitude": post.longitude,
                            "weather": post.weather,
                            "userId": myUid,
                            "timestamp": timestamp,
                            ] as [String:Any]

                // FirebaseDBへ登録
                FirebaseClient.setValue(id: "post", feed: feed, withCompletionBlock: self.postComplate)
            }
        }
    }

    func postComplate(error: Error?, ref: DatabaseReference) {
        self.delegate?.interactor(self, error: error)
    }

}
