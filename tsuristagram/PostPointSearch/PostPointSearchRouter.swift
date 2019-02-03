//
//  PostPointSearchRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

protocol PostPointSearchRouter {
    func backButton()
//    func fetchPointList(pointList: [Point])
}

class PostPointSearchRouterImpl: PostPointSearchRouter {
    
    fileprivate weak var postPointSearchViewController: PostPointSearchViewController?
    fileprivate var postViewController: PostViewController?

    init(postPointSearchViewController: PostPointSearchViewController,
         postViewController: PostViewController) {
        self.postPointSearchViewController = postPointSearchViewController
        self.postViewController = postViewController
    }

    func backButton() {
        postPointSearchViewController?.dismiss(animated: true, completion: nil)
    }
    
}
