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

}

// MARK: - interactor
protocol UserPageUsecase: class {
    func fetchUserData(userId: String)
    func fetchData(userId: String)

}

protocol UserPageInteractorDelegate: class {
    func interactor(_ userPageUsecase: UserPageUsecase, user: User)
    func interactor(_ userPageUsecase: UserPageUsecase, post: Post)
}

// MARK: - router
protocol UserPageWireframe: class {
    func selectCell(post: Post)

}
