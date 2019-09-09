//
//  TImeLineRouter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/28.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import YPImagePicker


class TimeLineRouter: TimeLineWireframe {
    
    var selectedItems = [YPMediaItem]()
    var post = Post()
    
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
        
        var config = YPImagePickerConfiguration()
        config.shouldSaveNewPicturesToAlbum = true
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.albumName = "FishTips"
        config.startOnScreen = .library
//        config.screens = [.library, .photo]
        config.screens = [.library]
        config.showsCrop = .none
        config.targetImageSize = .original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.showsCrop = .rectangle(ratio: (4/2.7))
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            self.selectedItems = items

            let image = items.singlePhoto?.image as! UIImage
            let assetUrl = items.singlePhoto?.asset
            let postVC = PostRouter.assembleModules() as! PostViewController
            
            let _ = postVC.view // ** hack code **
            self.post.uploadPhotoImage = image
            self.post.assetUrl_ujgawa = assetUrl
            postVC.post = self.post
            postVC.getPhotoMetaData()
            
            let navigationController = UINavigationController(rootViewController: postVC)
            picker.present(navigationController, animated: true)
            //  picker.dismiss(animated: true, completion: nil)
        }
        timeLineViewController!.present(picker, animated: true, completion: nil)

    }

    func selectUser(userId: String) {
        let userPageViewController = UserPageRouter.assembleModules() as! UserPageViewController
        userPageViewController.userId = userId
        
        timeLineViewController?.navigationController?.pushViewController(userPageViewController, animated: true)

    }

    func selectPoint(point: Point) {
        let pointDetailViewController = PointDetailRouter.assembleModules() as! PointDetailViewController
        pointDetailViewController.point = point
        
        timeLineViewController?.navigationController?.pushViewController(pointDetailViewController, animated: true)
    }

    func selectPost(postKey: String, userId: String) {
        let postDetailViewController = PostDetailRouter.assembleModules() as! PostDetailViewController
        postDetailViewController.postKey = postKey
        postDetailViewController.userId = userId

        timeLineViewController?.navigationController?.pushViewController(postDetailViewController, animated: true)
    }

}
