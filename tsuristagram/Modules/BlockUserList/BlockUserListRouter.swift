//
//  BlockUserListRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class BlockUserListRouter: BlockUserListWireframe {

    fileprivate weak var blockUserListViewController: BlockUserListViewController?
    fileprivate var tabBarController: UITabBarController?

    init(blockUserListViewController: BlockUserListViewController, tabBarController: UITabBarController) {
        self.blockUserListViewController = blockUserListViewController
        self.tabBarController = tabBarController
    }

    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "blockUserList") as! BlockUserListViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController

        let router = BlockUserListRouter(blockUserListViewController: view, tabBarController: tabbar!)
        let interactor = BlockUserListInteractor()
        let presenter = BlockUserListViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }
    
    func present() {
        // ユーザブロックした場合は、タイムラインデータを再取得
        let nav = blockUserListViewController?.navigationController
        let view = nav!.viewControllers[nav!.viewControllers.count-2] as! TimeLineViewController
        view.initialize()
        
        blockUserListViewController?.present(tabBarController!, animated: true, completion: nil)

    }
    
    func back() {
        blockUserListViewController?.present(tabBarController!, animated: true, completion: nil)
    }

}
