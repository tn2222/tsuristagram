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
    
    var post = Post() {
        didSet {
            view.setPostData(post: post)
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

}

// Interactorからの通知受け取り
extension PostDetailViewPresenter: PostDetailInteractorDelegate {
    func interactor(_ postDetailUsecase: PostDetailUsecase, post: Post) {
        self.post = post
        interactor.fetchPoint(pointId: post.pointId)
    }
    func interactor(_ postDetailUsecase: PostDetailUsecase, point: Point) {
        self.post.pointName = point.name
    }

    func interactor(_ postDetailUsecase: PostDetailUsecase, error: Error?) {
        router.deleteComplate()
    }
}
