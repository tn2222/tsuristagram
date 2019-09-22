//
//  PostDetailRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostDetailRouter: PostDetailWireframe {
    
    fileprivate weak var postDetailViewController: PostDetailViewController?
    fileprivate var postPointLocationViewController: PostPointLocationViewController?
    fileprivate var tabBarController: UITabBarController?
    
    init(postDetailViewController: PostDetailViewController,
         postPointLocationViewController: PostPointLocationViewController,
         tabBarController: UITabBarController) {
        self.postDetailViewController = postDetailViewController
        self.postPointLocationViewController = postPointLocationViewController
        self.tabBarController = tabBarController
    }

    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postDetail") as! PostDetailViewController
        
        let postLocationVC = storyboard.instantiateViewController(withIdentifier: "postPointLocation") as? PostPointLocationViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController
        
        let router = PostDetailRouter(postDetailViewController: view, postPointLocationViewController: postLocationVC!, tabBarController: tabbar!)
        let interactor = PostDetailInteractor()
        let presenter = PostDetailViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func pointLocationButton(latitude: Double, longitude: Double) {
        let postPointLocationViewController = PostPointLocationRouter.assembleModules() as! PostPointLocationViewController
        
        // 緯度経度を設定
        postPointLocationViewController.latitude = latitude
        postPointLocationViewController.longitude = longitude
        postPointLocationViewController.editFlag = false

        postDetailViewController?.navigationController?.pushViewController(postPointLocationViewController, animated: true)
    }

    func deleteComplate() {
        SVProgressHUD.dismiss()
        postDetailViewController?.present(tabBarController!, animated: true, completion: nil)
    }
    
    func userButton(userId: String) {
        let userPageViewController = UserPageRouter.assembleModules() as! UserPageViewController
        userPageViewController.userId = userId
        userPageViewController.tabHiddenFlag = true

        postDetailViewController?.tabBarController?.tabBar.isHidden = true
        postDetailViewController?.navigationController?.pushViewController(userPageViewController, animated: true)
    }
    
    func pointButton(point: Point) {
        let pointDetailViewController = PointDetailRouter.assembleModules() as! PointDetailViewController
        pointDetailViewController.point = point
        
        postDetailViewController?.tabBarController?.tabBar.isHidden = true
        postDetailViewController?.navigationController?.pushViewController(pointDetailViewController, animated: true)

    }

    func presentEditView(post: Post) {
        let postVC = PostRouter.assembleModules() as! PostViewController
        postVC.post = post
        postVC.showMapViewFlag = true

        let navigationController = UINavigationController(rootViewController: postVC)
        postDetailViewController!.present(navigationController, animated: true, completion: nil)
    }

}
