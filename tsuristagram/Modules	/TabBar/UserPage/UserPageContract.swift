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
}

// MARK: - interactor
protocol UserPageUsecase: class {
    func fetchUserData(userId: String)
}

protocol UserPageInteractorDelegate: class {
    func interactor(_ userPageUsecase: UserPageUsecase, user: User)
}

// MARK: - router
protocol UserPageWireframe: class {
}
