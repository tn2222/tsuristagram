//
//  BlockUserListViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class BlockUserListViewPresenter: BlockUserListViewPresentable {

    let view: BlockUserListViewController
    let router: BlockUserListWireframe
    let interactor: BlockUserListUsecase

    var userList = [User]()

    var user = User()  {
        didSet {
            view.setUser(user: user)
        }
    }

    init(view: BlockUserListViewController, router: BlockUserListWireframe, interactor: BlockUserListUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func fetchUserData(userId: String) {
        interactor.fetchUserData(userId: userId)
    }

    func userUnBlock(userId: String) {
        interactor.userUnBlock(userId: userId)
    }

    func back() {
        router.back()
    }
}

// Interactorからの通知受け取り
extension BlockUserListViewPresenter: BlockUserListInteractorDelegate {
    func interactor(_ blockUserListUsecase: BlockUserListUsecase, user: User) {
        self.user = user
        interactor.fetchBlockUserList(blockUserList: user.blockUserList)
    }
    func interactor(_ blockUserListUsecase: BlockUserListUsecase, blockUserList user: User) {
        userList.append(user)
        view.setUserList(userList: userList)
    }
}
