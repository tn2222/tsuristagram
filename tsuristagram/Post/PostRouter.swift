//
//  PostRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

protocol PostRouter {
    func postButton()
    func cancelButton()
    func pointDetailButton();
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
        
    }
    
    func cancelButton() {
        postViewController?.present(tabBarController!, animated: true, completion: nil)
    }

    func pointDetailButton() {
        postPointDetailViewController?.post = postViewController!.post
        postViewController?.present(postPointDetailViewController!,animated: true, completion: nil)
    }
    
    
}

