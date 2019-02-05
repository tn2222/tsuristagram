//
//  PostRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostRouter: PostPointWireframe {
    
    fileprivate weak var postViewController: PostViewController?
    fileprivate weak var postPointDetailViewController: PostPointDetailViewController?
    fileprivate weak var postPointSearchViewController: PostPointSearchViewController?
    fileprivate weak var tabBarController: UITabBarController?

    init(postViewController: PostViewController,
         postPointDetailViewController: PostPointDetailViewController,
         postPointSearchViewController: PostPointSearchViewController,
         tabBarController: UITabBarController) {
        self.postViewController = postViewController
        self.postPointDetailViewController = postPointDetailViewController
        self.postPointSearchViewController =  postPointSearchViewController
        self.tabBarController = tabBarController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postView") as! PostViewController

        let postDetailVC = storyboard.instantiateViewController(withIdentifier: "pointDetail") as? PostPointDetailViewController
        let postSearchVC = storyboard.instantiateViewController(withIdentifier: "pointSearch") as? PostPointSearchViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController
        let router = PostRouter(postViewController: view ,postPointDetailViewController: postDetailVC!, postPointSearchViewController: postSearchVC!, tabBarController: tabbar!)
        let interactor = PostInteractor()
        let presenter = PostViewPresenter(view: view, router: router, interactor: interactor)

        // Interactorの通知先を設定
//        interactor.delegate = presenter
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

    func pointDetailButton(post: Post) {
        postPointDetailViewController?.post = post
        postViewController?.present(postPointDetailViewController!,animated: true, completion: nil)
    }

    func pointSearchButton(post: Post) {
        let postPointSearchViewController = PostPointSearchRouter.assembleModules() as! PostPointSearchViewController

        postPointSearchViewController.post = post        
        postViewController?.navigationController?.pushViewController(postPointSearchViewController, animated: true)

    }

    func setPoint(pointName: String, pointId: String) {
        postViewController?.post.pointName = pointName
        postViewController?.pointName.text = pointName
        postViewController?.post.pointId = pointId
    }

}

