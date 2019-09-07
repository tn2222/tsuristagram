//
//  UserSettingsRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/08/18.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserSettingsRouter: UserSettingsWireframe {
    
    fileprivate weak var userSettingsViewController: UserSettingsViewController?
    fileprivate var tabBarController: UITabBarController?

    init(userSettingsViewController: UserSettingsViewController, tabBarController: UITabBarController) {
        self.userSettingsViewController = userSettingsViewController
        self.tabBarController = tabBarController

    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "userSettings") as! UserSettingsViewController
        
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController

        let router = UserSettingsRouter(userSettingsViewController: view, tabBarController: tabbar!)
        let interactor = UserSettingsInteractor()
        let presenter = UserSettingsViewPresenter(view: view, router: router, interactor: interactor)

        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }
    
    func present() {
        SVProgressHUD.dismiss()
        userSettingsViewController?.present(tabBarController!, animated: true, completion: nil)
    }
}
