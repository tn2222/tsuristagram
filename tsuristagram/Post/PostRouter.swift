//
//  PostRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol PostRouter {
    func postButton()
    func cancelButton()
    func pointDetailButton(post: Post)
    func setPoint(pointName: String);

}

class PostRouterImpl: PostRouter {
    
    fileprivate weak var postViewController: PostViewController?
    fileprivate var postPointDetailViewController: PostPointDetailViewController?
    fileprivate var tabBarController: UITabBarController?

    init(postViewController: PostViewController,
         postPointDetailViewController: PostPointDetailViewController,
         tabBarController: UITabBarController) {
        self.postViewController = postViewController
        self.postPointDetailViewController = postPointDetailViewController
        self.tabBarController = tabBarController
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
    
    func setPoint(pointName: String) {
        postViewController?.post.pointName = pointName
        postViewController?.pointName.text = pointName
    }

}

