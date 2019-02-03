//
//  PostPointSearchPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

protocol PostPointSearchPresenter {
    func backButton()
    func fetchPointData()
}

class PostPointSearchPresenterImpl: PostPointSearchPresenter {
    var post: Post
    let view: PostPointSearchViewController
    let router: PostPointSearchRouter
    let interactor: PostPointSearchInteractor
    var pointList = [Point]()  {
        didSet {
            view.tableView.reloadData()
        }
    }

    init(post: Post, view: PostPointSearchViewController, router: PostPointSearchRouter, interactor: PostPointSearchInteractor) {
        self.post = post
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func backButton() {
        self.router.backButton()
    }
    
    func fetchPointData() {
        interactor.fetchPointData()
    }
}

extension PostPointSearchPresenterImpl: PostPointSearchInteractorDelegate {
    
    func interactor(_ postPointSearchInteractor: PostPointSearchInteractor, pointList: [Point]) {
        self.pointList = pointList
    }
}

