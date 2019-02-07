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
    let router: PostPointSearchWireframe
    let interactor: PostPointSearchUsecase
    
    var pointList = [Point]()  {
        didSet {
            view.reloadData(pointList: pointList)
        }
    }

    init(view: PostPointSearchViewController, router: PostPointSearchWireframe, interactor: PostPointSearchUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchPointData(latitude: Double, longitude: Double) {
        interactor.fetchPointData(latitude: latitude, longitude: longitude)
    }
    
    func didSelectRow(point: Point) {
        router.didSelectRow(point: point) // Routerに画面遷移を依頼
    }

}

// Interactorからの通知受け取り
extension PostPointSearchViewPresenter: PostPointSearchInteractorDelegate {
    func interactor(_ postPointSearchUsecase: PostPointSearchUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
}

