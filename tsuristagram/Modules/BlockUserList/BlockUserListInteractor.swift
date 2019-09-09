//
//  BlockUserListInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

class BlockUserListInteractor: BlockUserListUsecase {
    
    // 取得処理の通知
    weak var delegate: BlockUserListInteractorDelegate?
    
    func fetchUserData(userId: String) {
        FirebaseClient.observeSingleEvent(id: "users", key: userId, of: .value, with: fetchUserComplate)
    }
    
    func fetchUserComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        user.userName = snapshot["userName"] as! String
        if snapshot["userBlock"] != nil {
            let blockUserList = snapshot["userBlock"] as! Dictionary<String, Bool>
            blockUserList.forEach{ (key, value) in
                user.blockUserList.append(key)
            }
        }
        self.delegate?.interactor(self, user: user)
    }

    func fetchBlockUserList(blockUserList: [String]) {
        blockUserList.forEach{ (userId) in
            FirebaseClient.observeSingleEvent(id: "users", key: userId, of: .value, with: fetchBlockUserListComplate)
        }
    }

    func fetchBlockUserListComplate(snapshot: [String:AnyObject]) {
        let user = User()
        user.userId = snapshot["userId"] as! String
        user.userName = snapshot["userName"] as! String
        user.userPhoto = snapshot["userPhoto"] as! String
        self.delegate?.interactor(self, blockUserList: user)
    }

    func userUnBlock(userId: String) {
        FirebaseClient.userUnBlock(id: "users", userId: CommonUtils.getUserId(), unblockUserId: userId, with: removeComplate)
    }

    func removeComplate(error: Error?, ref: DatabaseReference) {
        print("remove Complete")
    }
}
