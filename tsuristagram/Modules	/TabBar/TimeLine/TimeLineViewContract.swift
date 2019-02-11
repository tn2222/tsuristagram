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
}

// MARK: - interactor
protocol TimeLineUsecase: class {
    func fetchPostData()
    func fetchUserData()
    func fetchPointData()
}

protocol TimeLineInteractorDelegate: class {
    func interactor(_ timeLineUsecase: TimeLineUsecase, postList: [Post])
    func interactor(_ timeLineUsecase: TimeLineUsecase, pointMap: [String:NSDictionary])
    func interactor(_ timeLineUsecase: TimeLineUsecase, userMap: [String:NSDictionary])
    func done()
}

// MARK: - router
protocol TimeLineWireframe: class {
    func postButton()
}

