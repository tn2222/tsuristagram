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
                
                point.distance = CommonUtils.distance(current: (la: self.latitude, lo: self.longitude), target: (la: latitude, lo: longitude))
            }
            pointList.append(point)
        }
        self.delegate?.interactor(self, pointList: pointList)
    }

    
    func postButton(post: Post) {
        let currentTime = Date.currentTimeString()
        let timestamp: NSNumber = NSNumber(value:Int(Date().timeIntervalSince1970))

        let myUid = UserDefaults.standard.object(forKey: "userId") as! String

        let photoImageRef = Storage.storage().reference(forURL: "gs://tsuristagram.appspot.com").child("images").child(myUid).child(currentTime + ".jpg")
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
