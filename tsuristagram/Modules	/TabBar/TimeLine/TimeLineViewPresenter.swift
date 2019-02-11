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

    init(view: TimeLineViewController, router: TimeLineWireframe, interactor: TimeLineUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    // postデータを取得した後、紐付くusersとpointを取得する
    func fetchTimeLineData() {
        interactor.fetchPostData()
    }

    func postButton() {
        router.postButton()
    }
}

// Interactorからの通知受け取り
extension TimeLineViewPresenter: TimeLineInteractorDelegate {

    func interactor(_ timeLineUsecase: TimeLineUsecase, postList: [Post]) {
        interactor.fetchUserData()
        interactor.fetchPointData()
        timeLine.postList = postList
    }
    
    func interactor(_ timeLineUsecase: TimeLineUsecase, pointMap: [String:NSDictionary]) {
        timeLine.pointMap = pointMap
    }

    func interactor(_ timeLineUsecase: TimeLineUsecase, userMap: [String:NSDictionary]) {
        timeLine.userMap = userMap
    }
    
    func done() {
        if timeLine.postList.count <= 0 { return }
        if timeLine.userMap.count <= 0 { return }
        if timeLine.pointMap.count <= 0 { return }
        
        view.setTimeLineData(timeLine: timeLine)
    }
}
