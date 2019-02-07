//
//  PostPointSearchRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostPointSearchRouter: PostPointSearchWireframe {
    
    fileprivate weak var postPointSearchViewController: PostPointSearchViewController?

    init(postPointSearchViewController: PostPointSearchViewController) {
        self.postPointSearchViewController = postPointSearchViewController
    }

    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pointSearch = storyboard.instantiateViewController(withIdentifier: "pointSearch") as! PostPointSearchViewController
        let router = PostPointSearchRouter(postPointSearchViewController: pointSearch)
        let interactor = PostPointSearchInteractor()
        let presenter = PostPointSearchViewPresenter(view: pointSearch, router: router,interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        pointSearch.presenter = presenter
        
        return pointSearch
    }
    
    func didSelectRow(point: Point) {
        //呼び出し元のViewControllerを遷移履歴から取得し、パラメータを渡す
        let nav = postPointSearchViewController?.navigationController
        let pointView = nav!.viewControllers[nav!.viewControllers.count-2] as! PostViewController
        pointView.setPoint(id: point.id, name: point.name)
        //閉じる
        postPointSearchViewController?.navigationController?.popViewController(animated: true)
    }
    
}
