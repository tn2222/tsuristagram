//
//  PointSearchRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/17.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PointSearchRouter: PointSearchWireframe {
    
    fileprivate weak var pointSearchViewController: PointSearchViewController?
    
    init(pointSearchViewController: PointSearchViewController) {
        self.pointSearchViewController = pointSearchViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "pointSearch") as! PointSearchViewController
        
        let router = PointSearchRouter(pointSearchViewController: view)
        let interactor = PointSearchInteractor()
        let presenter = PointSearchViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func didSelectRow(point: Point) {
        let pointDetailViewController = PointDetailRouter.assembleModules() as! PointDetailViewController
        pointDetailViewController.point = point
        
        pointSearchViewController?.tabBarController?.tabBar.isHidden = true
        pointSearchViewController?.navigationController?.pushViewController(pointDetailViewController, animated: true)

    }

}
