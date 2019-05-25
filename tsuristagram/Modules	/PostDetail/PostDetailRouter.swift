//
//  PostDetailRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostDetailRouter: PostDetailWireframe {

    fileprivate weak var postDetailViewController: PostDetailViewController?
    fileprivate var postPointLocationViewController: PostPointLocationViewController?
    fileprivate var tabBarController: UITabBarController?
    
    init(postDetailViewController: PostDetailViewController,
         postPointLocationViewController: PostPointLocationViewController,
         tabBarController: UITabBarController) {
        self.postDetailViewController = postDetailViewController
        self.postPointLocationViewController = postPointLocationViewController
        self.tabBarController = tabBarController
    }

    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        
        let postLocationVC = storyboard.instantiateViewController(withIdentifier: "postPointLocation") as? PostPointLocationViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController
        
        let router = PostDetailRouter(postDetailViewController: view, postPointLocationViewController: postLocationVC!, tabBarController: tabbar!)
        let interactor = PostDetailInteractor()
        let presenter = PostDetailViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
//        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

}
