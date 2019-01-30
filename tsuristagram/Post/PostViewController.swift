//
//  PostViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Photos

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var size: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var fishSpecies: UITextField!
    @IBOutlet var fishingDate: UITextField!
    @IBOutlet var comment: UITextView!

    @IBOutlet var weather: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    
    var post = Post()
    
    var presenter: PostPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        // settings navigation bar
        self.navigationItem.title = "釣果登録"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.postButton))
        
        
        let postDetailVC = storyboard!.instantiateViewController(withIdentifier: "pointDetail") as? PostPointDetailViewController
        let tabbar = storyboard!.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController
        let router = PostRouterImpl(postViewController: self ,postPointDetailViewController: postDetailVC!, tabBarController: tabbar!)
        
        self.presenter = PostPresenterImpl(router: router)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getPoint(latitude: post.latitude, longitude: post.longitude)
        
        // dataClass to textField
        size.text = post.size
        weight.text = post.weight
        fishSpecies.text = post.fishSpecies
        fishingDate.text = post.fishingDate
        comment.text =  post.comment
        weather.text = post.weather
        uploadPhoto.image = post.uploadPhotoImage

    }

    /**
    * 写真アップロードをキャンセル。タイムラインページへ遷移
    */
    @objc func cancel(){
        presenter.cancelButton()
    }

    /**
    * firebaseにデータ登録
    */
    @objc func postButton(){
        SVProgressHUD.show()
        self.view?.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        presenter.postButton(post: self.post)
    }
    
    /**
    * 釣り場詳細画面へ遷移
    */
    @IBAction func pointDetail(_ sender: Any) {
        
        // textField to dataClassß
        post.size = size.text!
        post.weight = weight.text!
        post.fishSpecies = fishSpecies.text!
        post.fishingDate = fishingDate.text!
        post.comment = comment.text!
        post.weather = weather.text!
        post.uploadPhotoImage = uploadPhoto.image!

        presenter.pointDetailButton(post: self.post)
    }

    /**
     * カメラロールから選択した写真のメタ情報を取得
     */
    func getPhotoMetaData() {
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [self.post.assetUrl], options: nil)
        let asset = result.firstObject
        
        // コンテンツ編集セッションを開始するためのアセットの要求
        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            let url = contentEditingInput?.fullSizeImageURL
            let inputImage = CIImage(contentsOf: url!)!
            
            // Exif
            let exif = inputImage.properties["{Exif}"] as! Dictionary<String, Any>
            
            // 撮影日
            let dateTimeOriginal = exif["DateTimeOriginal"] as! String
            let dateTime = Date.stringToDate(string: dateTimeOriginal, format: "yyyy:MM:dd HH:mm:ss")
            let dateString = Date.dateToString(date: dateTime, format: "yyyy/MM/dd HH:mm")
            self.fishingDate.text = dateString
            self.post.fishingDate = dateString
            
            // 位置情報
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            if inputImage.properties["{GPS}"] as? Dictionary<String,Any> != nil {
                let gps = inputImage.properties["{GPS}"] as? Dictionary<String,Any>
                latitude = gps!["Latitude"] as! Double
                let latitudeRef = gps!["LatitudeRef"] as! String
                longitude = gps!["Longitude"] as! Double
                let longitudeRef = gps!["LongitudeRef"] as! String
                if latitudeRef == "S" {
                    latitude = latitude * -1
                }
                if longitudeRef == "W" {
                    longitude = longitude * -1
                }
            }
            self.post.latitude = latitude
            self.post.longitude = longitude
        })

        // ビューに表示する
        self.uploadPhoto.image = self.post.uploadPhotoImage
    }
    

}
