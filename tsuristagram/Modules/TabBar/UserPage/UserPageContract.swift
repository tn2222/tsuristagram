//
//  UserPageContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol UserPageView: class {
}

// MARK: - presenter
protocol UserPageViewPresentable: class {
    func fetchUserData(userId: String)
    func fetchData(userId: String)
    func selectCell(post: Post)
    func editButton(userId: String)
    func userBlock(userId: String)
    func report(reportType: Int, userId: String)
    func blockUserList(userId: String)

}

// MARK: - interactor
protocol UserPageUsecase: class {
    func fetchUserData(userId: String)
    func fetchData(userId: String)
    func userBlock(userId: String)
    func report(reportType: Int, userId: String)
}

protocol UserPageInteractorDelegate: class {
    func interactor(_ userPageUsecase: UserPageUsecase, user: User)
    func interactor(_ userPageUsecase: UserPageUsecase, post: Post)
    func interactor(_ userPageUsecase: UserPageUsecase, error: Error?)
}

// MARK: - router
protocol UserPageWireframe: class {
    func selectCell(post: Post)
    func editButton(userId: String)
    func blockUserList(userId: String)
    func present()
}
