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
    func disLike(likeButton: LikeButton)
    func like(likeButton: LikeButton)
    func selectUser(userId: String)
    func selectPoint(point: Point)
    func selectPost(postKey: String, userId: String)

}

// MARK: - interactor
protocol TimeLineUsecase: class {
    var isFetching: Bool {get}
    var isComplate: Bool {get}
    var offset: Int {get set}
    func fetchPostData()
    func disLike(likeButton: LikeButton)
    func like(likeButton: LikeButton)
    func fetchUserData(userId: String)
    func fetchPointData(pointId: String)
    func initialize()
}

protocol TimeLineInteractorDelegate: class {
    func interactor(_ timeLineUsecase: TimeLineUsecase, post: Post)
    func interactor(_ timeLineUsecase: TimeLineUsecase, user: User)
    func interactor(_ timeLineUsecase: TimeLineUsecase, own: User)
    func interactor(_ timeLineUsecase: TimeLineUsecase, point: Point)
    func interactor(_ timeLineUsecase: TimeLineUsecase)
    func disLike(_ timeLineUsecase: TimeLineUsecase, likeButton: LikeButton)
    func like(_ timeLineUsecase: TimeLineUsecase, likeButton: LikeButton)
    func done(type: String)
}

// MARK: - router
protocol TimeLineWireframe: class {
    func postButton()
    func selectUser(userId: String)
    func selectPoint(point: Point)
    func selectPost(postKey: String, userId: String)
}

