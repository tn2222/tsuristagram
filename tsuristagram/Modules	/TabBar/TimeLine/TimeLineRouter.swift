//
//  TImeLineRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class TimeLineRouter: TimeLineWireframe {

    fileprivate weak var timeLineViewController: TimeLineViewController?
    fileprivate weak var postViewController: PostViewController?

    init(timeLineViewController: TimeLineViewController, postViewController: PostViewController) {
        self.timeLineViewController = timeLineViewController
        self.postViewController = postViewController
    }
    
    // 依存関係の解決
    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "timeLine") as! TimeLineViewController
        let postVC = storyboard.instantiateViewController(withIdentifier: "postView") as! PostViewController
        
        let router = TimeLineRouter(timeLineViewController: view, postViewController: postVC)
        let interactor = TimeLineInteractor()
        let presenter = TimeLineViewPresenter(view: view, router: router, interactor: interactor)
        
        // Interactorの通知先を設定
        interactor.delegate = presenter
        // ViewにPresenterを設定
        view.presenter = presenter
        
        return view
    }

    func postButton() {
        // カメラロールが利用可能か
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = timeLineViewController
            // ビューに表示
            timeLineViewController!.present(pickerView, animated: true)
        }
    }
    

}
