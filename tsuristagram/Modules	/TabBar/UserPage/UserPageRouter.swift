//
//  UserPageRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class UserPageRouter: UserPageWireframe {

    
    fileprivate weak var userPageViewController: UserPageViewController?
    
    init(userPageViewController: UserPageViewController) {
        self.userPageViewController = userPageViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "userPage") as! UserPageViewController
        
        let router = UserPageRouter(userPageViewController: view)
        let interactor = UserPageInteractor()
        let presenter = UserPageViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

}

