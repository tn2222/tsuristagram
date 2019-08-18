//
//  UserSettingsInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/08/18.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class UserSettingsInteractor: UserSettingsUsecase {
    
    // 取得処理の通知
    weak var delegate: UserSettingsInteractorDelegate?

    func fetchUserData(userId: String) {
        FirebaseClient.observeSingleEvent(id: "users", key: userId, of: .value, with: fetchUserComplate)
    }
    
    func doneButton(user: User, isSelectPhoto: Bool) {
        let currentTime = Int(Date().timeIntervalSince1970)

        let myUid = CommonUtils.getUserId()

        if isSelectPhoto {
            let photoImageRef = Storage.storage().reference(forURL: "gs://tsuristagram.appspot.com").child("images").child(myUid).child("userImage.jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let photoImageUploadData = user.userPhotoImage.jpegData(compressionQuality: 0.1)
            
            // FireStoreへアップロード
            let uploadTask = photoImageRef.putData(photoImageUploadData!, metadata: metadata) { (metadata, err) in
                guard let metadata = metadata else { return }
                photoImageRef.downloadURL { (url, err) in
                    guard let url = url else { return }
                    
                    let feed = ["userName": user.userName,
                                "userPhoto": url.absoluteString,
                                "updatedAt": currentTime,
                                ] as [String:Any]
                    
                    // FirebaseDBへ登録
                    FirebaseClient.updateChildValues(id: "users", value: user.userId, feed: feed, with: self.updateComplate)
                }
            }
        } else {
            let feed = ["userName": user.userName,
                        "updatedAt": currentTime,
                        ] as [String:Any]

            // FirebaseDBへ登録
            FirebaseClient.updateChildValues(id: "users", value: user.userId, feed: feed, with: self.updateComplate)

        }
    }
    
    func updateComplate(error: Error?, ref: DatabaseReference) {
        self.delegate?.interactor(self, error: error)
    }

    func fetchUserComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        user.userName = snapshot["userName"] as! String
        self.delegate?.interactor(self, user: user)
    }

}
