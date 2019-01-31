//
//  PostPressenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

protocol PostPresenter {
//    var post: Post { get set }
    func getPoint(latitude: Double, longitude: Double)
    func postButton(post: Post)
    func cancelButton()
    func pointDetailButton(post: Post)
}

class PostPresenterImpl: PostPresenter {
    
    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String

    let router: PostRouter

    init(router: PostRouter) {
        self.router = router
    }

    func getPoint(latitude: Double, longitude: Double) {
        var nearest: Double?
        var nearestName: String!
        
        let ref = Database.database().reference()
        ref.child("point").observeSingleEvent(of: .value) { (snap,error) in
            let pointSnap = snap.value as? [String:NSDictionary]
            if pointSnap == nil {
                return
            }

            for (_,point) in pointSnap!{
                if let pointLatitude = point["latitude"] as? Double,
                   let pointLongitude = point["longitude"] as? Double,
                   let pointName = point["name"] as? String {
                    
                    var distance = self.distance(current: (la: latitude, lo: longitude), target: (la: pointLatitude, lo: pointLongitude))

                    if (nearest == nil) {
                        nearest = distance
                        nearestName = pointName
                    } else {
                        if (distance < nearest!) {
                            nearest = distance
                            nearestName = pointName
                        }
                    }
                }
            }
            print("一番近いポイント：" + nearestName + " 距離：" + "\(round(nearest!*10)/10)km")

        }
    }
        

    
    func postButton(post: Post) {
        let currentTime = Date.currentTimeString()
        let photoImageRef = Storage.storage().reference(forURL: "gs://tsuristagram.appspot.com").child("images").child(self.myUid).child(currentTime + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let photoImageUploadData = post.uploadPhotoImage.jpegData(compressionQuality: 0.1)
        
        // FireStoreへアップロード
        let uploadTask = photoImageRef.putData(photoImageUploadData!, metadata: metadata) { (metadata, err) in
            guard let metadata = metadata else { return }
            photoImageRef.downloadURL { (url, err) in
                guard let url = url else { return }
                
                // FirebaseDBへ登録
                let postRef = Database.database().reference(fromURL: "https://tsuristagram.firebaseio.com/").child("post").childByAutoId()
                
                let feed = ["size": post.size,
                            "weight": post.weight,
                            "fishSpecies": post.fishSpecies,
                            "comment": post.comment,
                            "fishingDate": post.fishingDate,
                            "picture": url.absoluteString,
                            "pointId": "", // TODO
                            "latitude": post.latitude,
                            "longitude": post.longitude,
                            "weather": post.weather,
                            "userId": self.myUid,
                            "createDate": currentTime,
                            ] as [String:Any]
                
                postRef.setValue(feed)
                
                self.router.postButton()
            }
        }
    }
    
    func cancelButton() {
        router.cancelButton()
    }
    
    func pointDetailButton(post: Post) {
        router.pointDetailButton(post: post)
    }
    
    /**
    * 2点間の距離算出（球面三角法）
    */
    func distance(current: (la: Double, lo: Double), target: (la: Double, lo: Double)) -> Double {
        
        // 緯度経度をラジアンに変換
        let currentLa   = current.la * Double.pi / 180
        let currentLo   = current.lo * Double.pi / 180
        let targetLa    = target.la * Double.pi / 180
        let targetLo    = target.lo * Double.pi / 180
        
        // 赤道半径
        let equatorRadius = 6378137.0;
        
        // 算出
        let averageLat = (currentLa - targetLa) / 2
        let averageLon = (currentLo - targetLo) / 2
        let distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)))
        return distance / 1000
    }
}
