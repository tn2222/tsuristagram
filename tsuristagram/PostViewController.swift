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
    @IBOutlet var fishingDate: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    
    var latitude = Double()
    var longitude = Double()
    var uploadPhotoImage : UIImage!
    var assetUrl : URL!
    
    // myUserId
    let myUid: String = UserDefaults.standard.object(forKey: "userId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // settings navigation bar
        self.navigationItem.title = "釣果登録"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.post))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUploadPhoto()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

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

    func showUploadPhoto() {

        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [self.assetUrl], options: nil)
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
        self.uploadPhoto.image = self.uploadPhotoImage
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
