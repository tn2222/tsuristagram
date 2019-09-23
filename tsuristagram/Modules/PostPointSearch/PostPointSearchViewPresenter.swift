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
            view.setPointList(pointList: pointList)
        }
    }

    init(view: PostPointSearchViewController, router: PostPointSearchWireframe, interactor: PostPointSearchUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchPointData(presentLatitude: Double, presentLongitude: Double) {
        interactor.fetchPointData(presentLatitude: presentLatitude, presentLongitude: presentLongitude)
    }

    // cellが呼ばれた場合
    func didSelectRow(point: Point) {
        router.didSelectRow(point: point)
    }
}

// Interactorからの通知受け取り
extension PostPointSearchViewPresenter: PostPointSearchInteractorDelegate {
    func interactor(_ postPointSearchUsecase: PostPointSearchUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
}
