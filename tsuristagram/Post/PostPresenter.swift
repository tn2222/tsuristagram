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
    var post: Post { get set }
    func postButton()
    func cancelButton()
    func pointDetailButton()
}

class PostPresenterImpl: PostPresenter {
    
    var post: Post
    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String

    let router: PostRouter

    init(post: Post, router: PostRouter) {
        self.post = post
        self.router = router
    }

    func postButton() {
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
                
                //                let feed = ["picture": url.absoluteString ,"comment": self.textField.text,"userId": self.myUid, "createDate": currentTime] as [String:Any]
                let feed = ["picture": url.absoluteString ,"userId": self.myUid, "createDate": currentTime] as [String:Any]
                
                postRef.setValue(feed)
            }
        }

    }
    
    func cancelButton() {
        router.cancelButton()
    }
    
    func pointDetailButton() {
        router.pointDetailButton()
    }
    

}
