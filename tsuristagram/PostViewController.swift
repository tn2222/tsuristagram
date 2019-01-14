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

    @IBOutlet var fishingDate: UITextField!
    //    @IBOutlet var profileImageView: UIImageView!
//    @IBOutlet var nameLabel: UILabel!
//    @IBOutlet var textField: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    @IBOutlet var photoSelectButton: UIButton!
    
    var latitude = Double()
    var longitude = Double()
    let dateUtils = DateUtils()
    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String
    
    var tabBarMyIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.tabBarMyIndex = self.tabBarController!.selectedIndex
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        let tabBarIndex = self.tabBarController!.selectedIndex
//        // tabBarIndexが異なる場合は別タブに移動したと判断
//        if tabBarMyIndex != tabBarIndex {
////            textField.text = ""
//            photoSelectButton.isHidden = false
//            uploadPhoto.isHidden = true
//
//        }
    }

    func fetchUserData() {
        
        let ref = Database.database().reference()
        ref.child("users").child(self.myUid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userSnap = snapshot.value as? NSDictionary
            
            if userSnap == nil {
                return
            }

            let userName = userSnap?["userName"] as! String
            let userPhoto = userSnap?["userPhoto"] as! String
//            self.nameLabel.text = userName
//            self.profileImageView.sd_setImage(with: URL(string: userPhoto), completed:nil)
//            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width * 0.5
//            self.profileImageView.clipsToBounds = true

        })

    }
    
    @IBAction func post(_ sender: Any) {
        
        if uploadPhoto == nil {
            print("写真が選択されていません")
            return
        }

        SVProgressHUD.show()

        let arrayOfTabBarItems = self.tabBarController!.tabBar.items
        for item in arrayOfTabBarItems!{
            item.isEnabled = false
        }

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

//                self.textField.text = ""
                
                for item in arrayOfTabBarItems!{
                    item.isEnabled = true
                }
                self.tabBarController!.selectedIndex = 0;

            }
        }

    }
    
    @IBAction func photoSelect(_ sender: Any) {
        // カメラロールが利用可能か
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        
        uploadPhoto.isHidden = false

        // 選択した写真を取得する
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 選択したアイテムの元のバージョンのAssets Library URL
        let assetUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
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
            let dateString = self.dateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss")
            self.fishingDate.text = dateString

            // 位置情報
            if inputImage.properties["{GPS}"] as? Dictionary<String,Any> == nil {
                print("この写真にはGPS情報がありません")
            } else {
                let gps = inputImage.properties["{GPS}"] as? Dictionary<String,Any>
                self.latitude = gps!["Latitude"] as! Double
                let latitudeRef = gps!["LatitudeRef"] as! String
                self.longitude = gps!["Longitude"] as! Double
                let longitudeRef = gps!["LongitudeRef"] as! String
                if latitudeRef == "S" {
                    self.latitude = self.latitude * -1
                }
                if longitudeRef == "W" {
                    self.longitude = self.longitude * -1
                }
            }
        })

        // ビューに表示する
        self.uploadPhoto.image = image
        photoSelectButton.isHidden = true
//        let photoImageUploadData = self.uploadPhoto.image?.jpegData(compressionQuality: 0.3)

        // 写真を選ぶビューを引っ込める
        picker.dismiss(animated: true)

    }

    @IBAction func pointDetail(_ sender: Any) {
        performSegue(withIdentifier: "postPointDetail",sender: nil)
    }
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "postPointDetail") {
            let detail: PostPointDetailViewController = (segue.destination as? PostPointDetailViewController)!
            detail.latitude = self.latitude
            detail.longitude = self.longitude
        }
    }

}
