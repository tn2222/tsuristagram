//
//  UserSettingsViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/08/18.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class UserSettingsViewPresenter: UserSettingsViewPresentable {
    
    let view: UserSettingsViewController
    let router: UserSettingsWireframe
    let interactor: UserSettingsUsecase
    
    var user = User()  {
        didSet {
            view.setUser(user: user)
        }
    }

    init(view: UserSettingsViewController, router: UserSettingsWireframe, interactor: UserSettingsUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func fetchUserData(userId: String) {
        interactor.fetchUserData(userId: userId)
    }

    func doneButton(user: User, isSelectPhoto: Bool) {
        interactor.doneButton(user: user, isSelectPhoto: isSelectPhoto)
    }

    func present() {
        router.present()
    }

}

// Interactorからの通知受け取り
extension UserSettingsViewPresenter: UserSettingsInteractorDelegate {
    func interactor(_ UserSettingsUsecase: UserSettingsUsecase, error: Error?) {
        router.present()
    }

    func interactor(_ UserSettingsUsecase: UserSettingsUsecase, user: User) {
        self.user = user
    }
}
