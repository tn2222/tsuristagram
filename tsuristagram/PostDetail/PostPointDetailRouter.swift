//
//  PostPointDetailRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/24.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

protocol PostPointDetailRouter {
    func backButton()
    func saveButton()
}

class PostPointDetailRouterImpl: PostPointDetailRouter {
    fileprivate weak var postPointDetailViewController: PostPointDetailViewController?
    fileprivate var postViewController: PostViewController?

    init(postPointDetailViewController: PostPointDetailViewController,
         postViewController: PostViewController) {
        self.postPointDetailViewController = postPointDetailViewController
        self.postViewController = postViewController
    }

    func backButton() {
        postPointDetailViewController?.dismiss(animated: true, completion: nil)
    }
    
    func saveButton() {
        let navigationController = UINavigationController(rootViewController: postViewController!)
        postPointDetailViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    
}
