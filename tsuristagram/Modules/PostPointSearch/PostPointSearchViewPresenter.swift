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

    init(view: PostPointSearchViewController, router: PostPointSearchWireframe) {
        self.view = view
        self.router = router
    }

    // cellが呼ばれた場合
    func didSelectRow(point: Point) {
        router.didSelectRow(point: point)
    }
}
