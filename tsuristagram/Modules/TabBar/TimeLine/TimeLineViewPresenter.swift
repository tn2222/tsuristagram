//
//  TimeLinePresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class TimeLineViewPresenter: TimeLinePresentable {
    
    let view: TimeLineViewController
    let router: TimeLineWireframe
    let interactor: TimeLineUsecase
    
    var timeLine = TimeLine()
    var userCount = 0
    var pointCount = 0
    init(view: TimeLineViewController, router: TimeLineWireframe, interactor: TimeLineUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func initialize() {
        interactor.initialize()
    }

    // postデータを取得した後、紐付くusersを取得
    func fetchTimeLineData() {
        interactor.fetchPostData()
    }

    func postButton() {
        router.postButton()
    }
    
    func selectUser(userId: String) {
        router.selectUser(userId: userId)
    }
    
    func selectPoint(point: Point) {
        router.selectPoint(point: point)
    }
    func selectPost(postKey: String, userId: String) {
        router.selectPost(postKey: postKey, userId: userId)
    }

}

// Interactorからの通知受け取り
extension TimeLineViewPresenter: TimeLineInteractorDelegate {
    func interactor(_ timeLineUsecase: TimeLineUsecase, point: Point) {
        timeLine.pointMap.updateValue(point, forKey: point.id)
    }
    
    func interactor(_ timeLineUsecase: TimeLineUsecase) {
        view.initializeComplate()
    }

    func interactor(_ timeLineUsecase: TimeLineUsecase, post: Post) {
        timeLine.postList.append(post)
        interactor.fetchPointData(pointId: post.pointId)
        interactor.fetchUserData(userId: post.userId)
    }
    
    func interactor(_ timeLineUsecase: TimeLineUsecase, user: User) {
        timeLine.userMap.updateValue(user, forKey: user.userId)
    }

    func done(type: String) {
        if type == "users" {
            userCount += 1
        } else {
            pointCount += 1
        }
        if !interactor.isFetching {
            guard timeLine.postList.count == userCount else { return }
            guard timeLine.postList.count == pointCount else { return }
            view.complateFetchTimeLineData(timeLine: timeLine, isComplate: interactor.isComplate)
        }
    }
}
