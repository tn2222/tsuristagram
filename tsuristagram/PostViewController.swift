//
//  PostViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import SVProgressHUD
import Photos

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let dateUtils = DateUtils()
    @IBOutlet var size: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var fishSpecies: UITextField!
    @IBOutlet var fishingDate: UITextField!
    @IBOutlet var comment: UITextField!
    @IBOutlet var weather: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    
    var postData = PostData()

    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // settings navigation bar
        self.navigationItem.title = "釣果登録"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.post))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFiled()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    /**
    * 写真アップロードをキャンセル。タイムラインページへ遷移
    */
    @objc func cancel(){
        if let tabbar = (storyboard!.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController) {
            self.present(tabbar, animated: true, completion: nil)
        }
    }

    /**
    * firebaseにデータ登録
    */
    @objc func post(){
        
        SVProgressHUD.show()
        
        let currentTime = dateUtils.currentTimeString()
        let photoImageRef = Storage.storage().reference(forURL: "gs://tsuristagram.appspot.com").child("images").child(self.myUid).child(currentTime + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let photoImageUploadData = self.uploadPhoto.image?.jpegData(compressionQuality: 0.1)
        
        // FireStoreへアップロード
        let uploadTask = photoImageRef.putData(photoImageUploadData!, metadata: metadata) { (metadata, err) in
            guard let metadata = metadata else { return }
            photoImageRef.downloadURL { (url, err) in
                guard let url = url else { return }
                
                // FirebaseDBへ登録
                let postRef = Database.database().reference(fromURL: "https://tsuristagram.firebaseio.com/").child("post").childByAutoId()
                
                //                let feed = ["picture": url.absoluteString ,"comment": self.textField.text,"userId": self.myUid, "createDate": currentTime] as [String:Any]
                let feed = ["picture": url.absoluteString ,"userId": self.myUid, "createDate": currentTime] as [String:Any]
                
                postRef.setValue(feed)
                
                SVProgressHUD.dismiss()
            }
        }
    }

    /**
    * postDataの値をフィールドに設定
    */
    func setFiled() {
        size.text = postData.size
        weight.text = postData.weight
        fishSpecies.text = postData.fishSpecies
        fishingDate.text = postData.fishingDate
        comment.text =  postData.comment
        weather.text = postData.weather
        uploadPhoto.image = postData.uploadPhotoImage
    }
    
    /**
     * フィールドの値をpostDataに設定
     */
    func setPostData() {
        postData.size = size.text!
        postData.weight = weight.text!
        postData.fishSpecies = fishSpecies.text!
        postData.fishingDate = fishingDate.text!
        postData.comment = comment.text!
        postData.weather = weather.text!
        postData.uploadPhotoImage = uploadPhoto.image!

    }
    
    /**
    * カメラロールから選択した写真のメタ情報を取得
    */
    func getPhotoMetaData() {
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [self.postData.assetUrl], options: nil)
        let asset = result.firstObject
        
        // コンテンツ編集セッションを開始するためのアセットの要求
        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            let url = contentEditingInput?.fullSizeImageURL
            let inputImage = CIImage(contentsOf: url!)!
            
            // Exif
            let exif = inputImage.properties["{Exif}"] as! Dictionary<String, Any>
            
            // 撮影日
            let dateTimeOriginal = exif["DateTimeOriginal"] as! String
            let date = self.dateUtils.dateFromString(string: dateTimeOriginal, format: "yyyy:MM:dd HH:mm:ss")
            let dateString = self.dateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm")
            self.fishingDate.text = dateString
            self.postData.fishingDate = dateString
            
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
            self.postData.latitude = latitude
            self.postData.longitude = longitude
        })

        // ビューに表示する
        self.uploadPhoto.image = self.postData.uploadPhotoImage
    }
    
    /**
    * 釣り場詳細画面へ遷移
    */
    @IBAction func pointDetail(_ sender: Any) {
        let postDetailVC = storyboard!.instantiateViewController(withIdentifier: "pointDetail") as? PostPointDetailViewController

        setPostData()
        postDetailVC?.postData = self.postData
        self.present(postDetailVC!,animated: true, completion: nil)

    }

}
