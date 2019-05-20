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
    
    var user = User()  {
        didSet {
            view.setUser(user: user)
        }
    }
    
    init(view: UserPageViewController, router: UserPageWireframe, interactor: UserPageUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchUserData(userId: String) {
        interactor.fetchUserData(userId: userId)
    }

}

// Interactorからの通知受け取り
extension UserPageViewPresenter: UserPageInteractorDelegate {
    func interactor(_ userPageUsecase: UserPageUsecase, user: User) {
        self.user = user
    }
}
