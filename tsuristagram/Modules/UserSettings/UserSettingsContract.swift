//
//  UserSettingsContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/08/18.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol UserSettingsView: class {
}

// MARK: - presenter
protocol UserSettingsViewPresentable: class {
    func fetchUserData(userId: String)
    func doneButton(user: User, isSelectPhoto: Bool)
    func present()
}

// MARK: - interactor
protocol UserSettingsUsecase: class {
    func fetchUserData(userId: String)
    func doneButton(user: User, isSelectPhoto: Bool)
}

protocol UserSettingsInteractorDelegate: class {
    func interactor(_ userSettingsUsecase: UserSettingsUsecase, user: User)
    func interactor(_ userSettingsUsecase: UserSettingsUsecase, error: Error?)
}

// MARK: - router
protocol UserSettingsWireframe: class {
    func present()
}
