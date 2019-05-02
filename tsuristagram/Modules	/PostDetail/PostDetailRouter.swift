//
//  PostDetailRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostDetailRouter: PostDetailWireframe {

    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postView") as! PostViewController
        
        let postLocationVC = storyboard.instantiateViewController(withIdentifier: "postPointLocation") as? PostPointLocationViewController
        let postSearchVC = storyboard.instantiateViewController(withIdentifier: "postPointSearch") as? PostPointSearchViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController
        
        let router = PostRouter(postViewController: view ,postPointLocationViewController: postLocationVC!, postPointSearchViewController: postSearchVC!, tabBarController: tabbar!)
        let interactor = PostInteractor()
        let presenter = PostViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

}
