//
//  PostDetailViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PostDetailViewPresenter: PostDetailViewPresentable {
    
    let view: PostDetailViewController
    let router: PostDetailWireframe
    let interactor: PostDetailUsecase
    
    var user = User()  {
        didSet {
            view.setUser(user: user)
        }
    }
    var post = Post() {
        didSet {
            view.setPostData(post: post)
        }
    }
    var point = Point() {
        didSet {
            view.setPoint(point: point)
        }
    }

    init(view: PostDetailViewController, router: PostDetailWireframe, interactor: PostDetailUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func pointLocationButton(latitude: Double, longitude: Double) {
        router.pointLocationButton(latitude: latitude, longitude: longitude)
    }

    func fetchData(postKey: String) {
        interactor.fetchData(postKey: postKey)
    }

    func deleteButton(post: Post) {
        interactor.deleteButton(post: post)
    }
    
    func disLike(likeButton: LikeButton) {
        interactor.disLike(likeButton: likeButton)
    }
    
    func like(likeButton: LikeButton) {
        interactor.like(likeButton: likeButton)
    }
    
    func userButton(userId: String) {
        router.userButton(userId: userId)
    }
    
    func pointButton(point: Point) {
        router.pointButton(point: point)
    }

    func presentEditView(post: Post) {
        router.presentEditView(post: post)
    }
}

// Interactorからの通知受け取り
extension PostDetailViewPresenter: PostDetailInteractorDelegate {
    func interactor(_ postDetailUsecase: PostDetailUsecase, user: User) {
        self.user = user
    }
    func interactor(_ postDetailUsecase: PostDetailUsecase, post: Post) {
        self.post = post
        interactor.fetchUserData(userId: post.userId)
        interactor.fetchPoint(pointId: post.pointId)
    }
    func interactor(_ postDetailUsecase: PostDetailUsecase, point: Point) {
        self.point = point
    }

    func interactor(_ postDetailUsecase: PostDetailUsecase, error: Error?) {
        router.deleteComplate()
    }
    
    func disLike(_ postDetailUsecase: PostDetailUsecase, likeButton: LikeButton) {
        view.setLikeButton(likeButton: likeButton)
    }
    
    func like(_ postDetailUsecase: PostDetailUsecase, likeButton: LikeButton) {
        view.setLikeButton(likeButton: likeButton)
    }
}
