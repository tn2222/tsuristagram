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

    func disLike(likeButton: LikeButton) {
        interactor.disLike(likeButton: likeButton)
    }
    
    func like(likeButton: LikeButton) {
        interactor.like(likeButton: likeButton)
    }

    // postデータを取得した後、紐付くusersを取得
    func fetchTimeLineData() {
        interactor.fetchPostData()
    }

    func resetFetchOffset() {
        userCount = 0
        pointCount = 0
        interactor.offset = (-1) * Int(Date().timeIntervalSince1970)
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

    func interactor(_ timeLineUsecase: TimeLineUsecase, post: Post) -> Void {
        // ブロックされていないユーザのみ表示対象
        if !timeLine.user.blockUserList.contains(post.userId) {
            timeLine.postList.append(post)
            var likeInfo = LikeInfo()
            likeInfo.key = post.key
            likeInfo.isLike = post.likesFlag
            view.likesMap.updateValue(likeInfo, forKey: post.key)
            interactor.fetchPointData(pointId: post.pointId)
            interactor.fetchUserData(userId: post.userId)
        }
    }
    
    func interactor(_ timeLineUsecase: TimeLineUsecase, own: User) {
        timeLine.user = own
    }
    func interactor(_ timeLineUsecase: TimeLineUsecase, user: User) {
        timeLine.userMap.updateValue(user, forKey: user.userId)
    }
    func disLike(_ timeLineUsecase: TimeLineUsecase, likeButton: LikeButton) {
        view.setLikeButton(likeButton: likeButton)
    }
    func like(_ timeLineUsecase: TimeLineUsecase, likeButton: LikeButton) {
        view.setLikeButton(likeButton: likeButton)
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
