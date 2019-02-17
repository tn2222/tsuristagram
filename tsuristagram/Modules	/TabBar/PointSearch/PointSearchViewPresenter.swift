//
//  PointSearchViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/17.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PointSearchViewPresenter: PointSearchViewPresentable {
    
    let view: PointSearchViewController
    let router: PointSearchWireframe
    let interactor: PointSearchUsecase
    
    var pointList = [Point]()  {
        didSet {
            view.setPointList(pointList: pointList)
        }
    }

    init(view: PointSearchViewController, router: PointSearchWireframe, interactor: PointSearchUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchPointData() {
        interactor.fetchPointData()
    }

}

// Interactorからの通知受け取り
extension PointSearchViewPresenter: PointSearchInteractorDelegate {
    
    func interactor(_ pointSearchUsecase: PointSearchUsecase, pointList: [Point]) {
        self.pointList = pointList
    }
    
}
