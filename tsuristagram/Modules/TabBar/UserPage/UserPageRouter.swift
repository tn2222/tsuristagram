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
    
    init(userPageViewController: UserPageViewController, postDetailViewController: PostDetailViewController) {
        self.userPageViewController = userPageViewController
        self.postDetailViewController = postDetailViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "userPage") as! UserPageViewController
        let postDetailVC = storyboard.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        
        let router = UserPageRouter(userPageViewController: view, postDetailViewController: postDetailVC)
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
        userPageViewController?.navigationController?.pushViewController(postDetailViewController, animated: true)
    }

}

