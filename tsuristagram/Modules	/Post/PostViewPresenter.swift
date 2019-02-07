//
//  PostPressenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class PostViewPresenter: PostViewPresentable {
    
    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String

    let view: PostViewController
    let router: PostWireframe
    let interactor: PostUsecase

    var pointList = [Point]()  {
        didSet {
            view.setPointList(pointList: pointList)
        }
    }
    
    init(view: PostViewController, router: PostWireframe, interactor: PostUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchPointData(latitude: Double, longitude: Double) {
        interactor.fetchPointData(latitude: latitude, longitude: longitude)
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
    
    func pointLocationButton(post: Post) {
        router.pointLocationButton(post: post)
    }

    func pointSearchButton(post: Post) {
        router.pointSearchButton(post: post)
    }
}

// Interactorからの通知受け取り
extension PostViewPresenter: PostInteractorDelegate {
    func interactor(_ postUsecase: PostUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
    
}
