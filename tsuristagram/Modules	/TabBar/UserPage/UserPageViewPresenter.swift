//
//  UserPageViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class UserPageViewPresenter: UserPageViewPresentable {
    
    let view: UserPageViewController
    let router: UserPageWireframe
    let interactor: UserPageUsecase
    
    
    init(view: UserPageViewController, router: UserPageWireframe, interactor: UserPageUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

}
