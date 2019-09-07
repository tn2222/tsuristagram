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
    fileprivate weak var postDetailViewController: PostDetailViewController?
    fileprivate var tabBarController: UITabBarController?

    init(userPageViewController: UserPageViewController, postDetailViewController: PostDetailViewController, tabBarController: UITabBarController) {
        self.userPageViewController = userPageViewController
        self.postDetailViewController = postDetailViewController
        self.tabBarController = tabBarController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "userPage") as! UserPageViewController
        let postDetailVC = storyboard.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController

        let router = UserPageRouter(userPageViewController: view, postDetailViewController: postDetailVC, tabBarController: tabbar!)
        let interactor = UserPageInteractor()
        let presenter = UserPageViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func selectCell(post: Post) {
        let postDetailViewController = PostDetailRouter.assembleModules() as! PostDetailViewController
        postDetailViewController.postKey = post.key
        postDetailViewController.userId = post.userId
        userPageViewController?.navigationController?.pushViewController(postDetailViewController, animated: true)
    }

    func editButton(userId: String) {
        let userSettingsViewController = UserSettingsRouter.assembleModules() as! UserSettingsViewController
        userSettingsViewController.userId = userId
        userPageViewController?.navigationController?.pushViewController(userSettingsViewController, animated: true)
    }

    func present() {
        
        // ユーザブロックした場合は、タイムラインデータを再取得
        let nav = userPageViewController?.navigationController
        let view = nav!.viewControllers[nav!.viewControllers.count-2] as! TimeLineViewController
        view.initialize()

        userPageViewController?.present(tabBarController!, animated: true, completion: nil)
    }

}

