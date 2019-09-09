//
//  BlockUserList.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol BlockUserListView: class {
}

// MARK: - presenter
protocol BlockUserListViewPresentable: class {
    func fetchUserData(userId: String)
    func userUnBlock(userId: String)
    func back()

}

// MARK: - interactor
protocol BlockUserListUsecase: class {
    func fetchUserData(userId: String)
    func fetchBlockUserList(blockUserList: [String])
    func userUnBlock(userId: String)
}

protocol BlockUserListInteractorDelegate: class {
    func interactor(_ BlockUserListUsecase: BlockUserListUsecase, user: User)
    func interactor(_ BlockUserListUsecase: BlockUserListUsecase, blockUserList: User)

}

// MARK: - router
protocol BlockUserListWireframe: class {
    func present()
    func back()
}
