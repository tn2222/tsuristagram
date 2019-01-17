//
//  TimeLineViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import Firebase
import Photos

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

//    var displayName = String()
//    var date = String()
//    var picture = String()
//    var uid = String()
//    var userPhoto = String()
    
    let refreshControl = UIRefreshControl()

    var userName_Array = [String]()
    var date_Array = [String]()
    var picture_Array = [String]()
    var uid_Array = [String]()
    var userPhoto_Array = [String]()

    var posts = [Post]()
    var post = Post()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.addSubview(refreshControl)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let userPhoto = cell.viewWithTag(1) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        userPhoto.sd_setImage(with: URL(string: self.posts[indexPath.row].userPhoto), completed:nil)

        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = self.posts[indexPath.row].userName

        
        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.posts[indexPath.row].picture), completed:nil)

        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
    
    @IBAction func postButton(_ sender: Any) {
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

        // 選択した写真を取得する
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        
//        // 選択したアイテムの元のバージョンのAssets Library URL
        let assetUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
//
//        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
//        let result = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
//        let asset = result.firstObject
//        
//        // コンテンツ編集セッションを開始するためのアセットの要求
//        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
//            let url = contentEditingInput?.fullSizeImageURL
//            let inputImage = CIImage(contentsOf: url!)!
//            
//            // Exif
//            let exif = inputImage.properties["{Exif}"] as! Dictionary<String, Any>
//            
//            // 撮影日
//            let dateTimeOriginal = exif["DateTimeOriginal"] as! String
//            let date = self.dateUtils.dateFromString(string: dateTimeOriginal, format: "yyyy:MM:dd HH:mm:ss")
//            let dateString = self.dateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss")
//            self.fishingDate.text = dateString
//            
//            // 位置情報
//            if inputImage.properties["{GPS}"] as? Dictionary<String,Any> == nil {
//                print("この写真にはGPS情報がありません")
//            } else {
//                let gps = inputImage.properties["{GPS}"] as? Dictionary<String,Any>
//                self.latitude = gps!["Latitude"] as! Double
//                let latitudeRef = gps!["LatitudeRef"] as! String
//                self.longitude = gps!["Longitude"] as! Double
//                let longitudeRef = gps!["LongitudeRef"] as! String
//                if latitudeRef == "S" {
//                    self.latitude = self.latitude * -1
//                }
//                if longitudeRef == "W" {
//                    self.longitude = self.longitude * -1
//                }
//            }
//        })
//        
//        // ビューに表示する
//        self.uploadPhoto.image = image
//        photoSelectButton.isHidden = true
//        //        let photoImageUploadData = self.uploadPhoto.image?.jpegData(compressionQuality: 0.3)
        
        
        
        let postVC = storyboard!.instantiateViewController(withIdentifier: "postView") as? PostViewController
        let _ = postVC?.view // ** hack code **
        postVC?.uploadPhotoImage = image
        postVC?.assetUrl = assetUrl
        
        picker.pushViewController(postVC!, animated: true)

//        self.present(postVC!,animated: true, completion: nil)
//
//        // 写真を選ぶビューを引っ込める
//        picker.dismiss(animated: true)

    }

    
    
    @objc func refresh(){
        fetchData()
        refreshControl.endRefreshing()
    }
    
    func fetchData() {
        self.post = Post()
        self.userName_Array = [String]()
        self.date_Array = [String]()
        self.picture_Array = [String]()
        self.uid_Array = [String]()
        self.userPhoto_Array = [String]()

        let ref = Database.database().reference()
        ref.child("post").observeSingleEvent(of: .value) { (snap,error) in

            let postsSnap = snap.value as? [String:NSDictionary]

            if postsSnap == nil {
                return
            }
            self.posts = [Post]()
            for (_,post) in postsSnap!{
                self.post = Post()

                if let uid = post["userId"] as? String, let date = post["createDate"] as? String,let picture = post["picture"] as? String{

                    self.post.uid = uid
                    self.post.date = date
                    self.post.picture = picture

                    self.uid_Array.append(self.post.uid)
                    self.date_Array.append(self.post.date)
                    self.picture_Array.append(self.post.picture)

                    ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let userSnap = snapshot.value as? NSDictionary

                        if userSnap == nil {
                            return
                        }
                        let userPhoto = userSnap?["userPhoto"] as! String
                        let userName = userSnap?["userName"] as! String
                        self.post.userPhoto = userPhoto
                        self.post.userName = userName

                        self.userPhoto_Array.append(self.post.userPhoto)
                        self.userName_Array.append(self.post.userName)

                        // プロフィール画像を取得したタイミングでtableViewリロード
                        self.tableView.reloadData()

                    })
                }
                self.posts.append(self.post)
            }
        }
    }
}
