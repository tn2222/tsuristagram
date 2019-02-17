//
//  PostRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostRouter: PostWireframe {
     
    fileprivate weak var postViewController: PostViewController?
    fileprivate var postPointLocationViewController: PostPointLocationViewController?
    fileprivate var postPointSearchViewController: PostPointSearchViewController?
    fileprivate var tabBarController: UITabBarController?

    init(postViewController: PostViewController,
         postPointLocationViewController: PostPointLocationViewController,
         postPointSearchViewController: PostPointSearchViewController,
         tabBarController: UITabBarController) {
        self.postViewController = postViewController
        self.postPointLocationViewController = postPointLocationViewController
        self.postPointSearchViewController =  postPointSearchViewController
        self.tabBarController = tabBarController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "postView") as! PostViewController

        let postLocationVC = storyboard.instantiateViewController(withIdentifier: "postPointLocation") as? PostPointLocationViewController
        let postSearchVC = storyboard.instantiateViewController(withIdentifier: "postPointSearch") as? PostPointSearchViewController
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController

        let router = PostRouter(postViewController: view ,postPointLocationViewController: postLocationVC!, postPointSearchViewController: postSearchVC!, tabBarController: tabbar!)
        let interactor = PostInteractor()
        let presenter = PostViewPresenter(view: view, router: router, interactor: interactor)

        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func postComplate() {
        SVProgressHUD.dismiss()
        postViewController?.present(tabBarController!, animated: true, completion: nil)
    }
    
    func cancelButton() {
        postViewController?.present(tabBarController!, animated: true, completion: nil)
    }

    func pointSearchButton(pointList: [Point]) {
        let postPointSearchViewController = PostPointSearchRouter.assembleModules() as! PostPointSearchViewController

        postPointSearchViewController.pointListAll = pointList
        postViewController?.navigationController?.pushViewController(postPointSearchViewController, animated: true)

    }
    
    func pointLocationButton(latitude: Double, longitude: Double) {
        let postPointLocationViewController = PostPointLocationRouter.assembleModules() as! PostPointLocationViewController
        
        // 緯度経度を設定
        postPointLocationViewController.latitude = latitude
        postPointLocationViewController.longitude = longitude

        postViewController?.navigationController?.pushViewController(postPointLocationViewController, animated: true)
    }

}

