//
//  PostRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostRouter: PostWireframe {
     
    fileprivate weak var postViewController: PostViewController?
    fileprivate var postPointLocationViewController: PostPointLocationViewController?
    fileprivate var postPointSearchViewController: PostPointSearchViewController?
    fileprivate var tabBarController: UITabBarController?

    init(postViewController: PostViewController,
         postPointLocationViewController: PostPointLocationViewController,
         postPointSearchViewController: PostPointSearchViewController,
         tabBarController: UITabBarController) {
        self.postViewController = postViewController
        self.postPointLocationViewController = postPointLocationViewController
        self.postPointSearchViewController =  postPointSearchViewController
        self.tabBarController = tabBarController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postView") as! PostViewController

        let postLocationVC = storyboard.instantiateViewController(withIdentifier: "pointLocation") as? PostPointLocationViewController
        let postSearchVC = storyboard.instantiateViewController(withIdentifier: "pointSearch") as? PostPointSearchViewController
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

    func postButton() {
        SVProgressHUD.dismiss()
        postViewController?.present(tabBarController!, animated: true, completion: nil)
    }
    
    func cancelButton() {
        postViewController?.present(tabBarController!, animated: true, completion: nil)
    }

    func pointSearchButton(post: Post) {
        let postPointSearchViewController = PostPointSearchRouter.assembleModules() as! PostPointSearchViewController

        postPointSearchViewController.post = post        
        postViewController?.navigationController?.pushViewController(postPointSearchViewController, animated: true)

    }
    
    func pointLocationButton(post: Post) {
        let postPointLocationViewController = PostPointLocationRouter.assembleModules() as! PostPointLocationViewController
        
        postPointLocationViewController.post = post
        postViewController?.navigationController?.pushViewController(postPointLocationViewController, animated: true)
    }

}

