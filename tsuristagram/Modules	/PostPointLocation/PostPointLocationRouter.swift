//
//  PostPointLocationRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/24.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostPointLocationRouter: PostPointLocationWireframe {
    fileprivate weak var postPointLocationViewController: PostPointLocationViewController?
    
    init(postPointLocationViewController: PostPointLocationViewController) {
        self.postPointLocationViewController = postPointLocationViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pointLocation = storyboard.instantiateViewController(withIdentifier: "postPointLocation") as! PostPointLocationViewController
        let router = PostPointLocationRouter(postPointLocationViewController: pointLocation)
        let presenter = PostPointLocationViewPresenter(view: pointLocation, router: router)
        
        // ViewにPresenterを設定
        pointLocation.presenter = presenter
        
        return pointLocation
    }

    func saveButton(latitude: Double, longitude:Double) {
        //呼び出し元のViewControllerを遷移履歴から取得し、パラメータを渡す
        let nav = postPointLocationViewController?.navigationController
        let pointView = nav!.viewControllers[nav!.viewControllers.count-2] as! PostViewController
        pointView.setLocation(latitude: latitude, longitude: longitude)
        //閉じる
        postPointLocationViewController?.navigationController?.popViewController(animated: true)

    }
    
    func backButton() {
        postPointLocationViewController?.navigationController?.popViewController(animated: true)
    }
    
}
