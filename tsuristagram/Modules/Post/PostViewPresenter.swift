//
//  PostPressenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PostViewPresenter: PostViewPresentable {
    
    let view: PostViewController
    let router: PostWireframe
    let interactor: PostUsecase

    var pointList = [Point]() {
        didSet {
            view.setPointList(pointList: pointList)
        }
    }
    
    init(view: PostViewController, router: PostWireframe, interactor: PostUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchPointData(latitude: Double, longitude: Double) {
        interactor.fetchPointData(latitude: latitude, longitude: longitude)
    }

    func updateButton(post: Post) {
        interactor.updateButton(post: post)
    }

    func postButton(post: Post) {
        interactor.postButton(post: post)
    }
    
    func updateCancelButton() {
        router.updateCancelButton()
    }

    func cancelButton() {
        router.cancelButton()
    }
    
    func pointLocationButton(latitude: Double, longitude: Double) {
        router.pointLocationButton(latitude: latitude, longitude: longitude)
    }

    func pointSearchButton(pointList: [Point]) {
        router.pointSearchButton(pointList: pointList)
    }
}

// Interactorからの通知受け取り
extension PostViewPresenter: PostInteractorDelegate {
    func interactor(_ postUsecase: PostUsecase, error: Error?) {
        router.postComplate()
    }
    
    func interactor(_ postUsecase: PostUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
    
}
