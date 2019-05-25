//
//  PointDetailRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PointDetailRouter: PointDetailWireframe {
    
    fileprivate weak var pointDetailViewController: PointDetailViewController?
    
    init(pointDetailViewController: PointDetailViewController) {
        self.pointDetailViewController = pointDetailViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "pointDetail") as! PointDetailViewController
        
        let router = PointDetailRouter(pointDetailViewController: view)
        let interactor = PointDetailInteractor()
        let presenter = PointDetailViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func selectCell(post: Post) {
        let postDetailViewController = PostDetailRouter.assembleModules() as! PostDetailViewController
        postDetailViewController.postKey = post.key
        pointDetailViewController?.navigationController?.pushViewController(postDetailViewController, animated: true)
    }

}
