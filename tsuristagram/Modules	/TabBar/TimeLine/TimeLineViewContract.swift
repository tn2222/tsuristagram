//
//  TimeLineViewVontroller.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol TimeLineView: class {
}

// MARK: - presenter
protocol TimeLinePresentable: class {
    func fetchTimeLineData()
    func postButton()
    func initialize()
    func selectUser(userId: String)
}

// MARK: - interactor
protocol TimeLineUsecase: class {
    var isFetching: Bool {get}
    var isComplate: Bool {get}
    func fetchPostData()
    func fetchUserData(userId: String)
    func initialize()
}

protocol TimeLineInteractorDelegate: class {
    func interactor(_ timeLineUsecase: TimeLineUsecase, post: Post)
    func interactor(_ timeLineUsecase: TimeLineUsecase, user: User)
    func interactor(_ timeLineUsecase: TimeLineUsecase)
    func done(type: String)
}

// MARK: - router
protocol TimeLineWireframe: class {
    func postButton()
    func selectUser(userId: String)
}

