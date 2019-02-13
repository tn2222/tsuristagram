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
    init(view: TimeLineViewController, router: TimeLineWireframe, interactor: TimeLineUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    // postデータを取得した後、紐付くusersを取得
    func fetchTimeLineData() {
        interactor.fetchPostData()
    }

    func postButton() {
        router.postButton()
    }
}

// Interactorからの通知受け取り
extension TimeLineViewPresenter: TimeLineInteractorDelegate {

    func interactor(_ timeLineUsecase: TimeLineUsecase, post: Post) {
        timeLine.postList.append(post)
        if timeLine.userMap[post.userId] == nil {
            interactor.fetchUserData(userId: post.userId)
        } else {
            done(type: "users")
        }
    }
    
    func interactor(_ timeLineUsecase: TimeLineUsecase, user: User) {
        timeLine.userMap.updateValue(user, forKey: user.userId)
    }

    func done(type: String) {
        userCount += 1
        guard timeLine.postList.count == userCount else { return }
        if !interactor.isFetching {
            view.complateFetchTimeLineData(timeLine: timeLine)
        }
        
    }
}
