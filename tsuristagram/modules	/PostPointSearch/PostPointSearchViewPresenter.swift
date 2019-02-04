//
//  PostPointSearchViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PostPointSearchViewPresenter: PostPointSearchViewPresentable {
    let view: PostPointSearchViewController
    let router: PostPointSearchRouter
    let interactor: PostPointSearchInteractor
    var pointList = [Point]()  {
        didSet {
            view.reloadData(pointList: pointList)
        }
    }

    init(view: PostPointSearchViewController, router: PostPointSearchRouter, interactor: PostPointSearchInteractor) {
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
    
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < pointList.count else { return }
        
        let point = pointList[indexPath.row]
        router.didSelectRow(point: point) // Routerに画面遷移を依頼
    }

}

// Interactorからの通知受け取り
extension PostPointSearchViewPresenter: PostPointSearchInteractorDelegate {
    func interactor(_ postPointSearchUsecase: PostPointSearchUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
}

