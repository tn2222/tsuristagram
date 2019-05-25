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
    
    var point = Point()
    
    init(view: PostDetailViewController, router: PostDetailWireframe, interactor: PostDetailUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

}
