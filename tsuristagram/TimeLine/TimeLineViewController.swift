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

    let refreshControl = UIRefreshControl()

    var userName_Array = [String]()
    var date_Array = [String]()
    var picture_Array = [String]()
    var uid_Array = [String]()
    var userPhoto_Array = [String]()

    var postDataList = [Post]()
    var postData = Post()

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
        return postDataList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let userPhoto = cell.viewWithTag(1) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        userPhoto.sd_setImage(with: URL(string: self.postDataList[indexPath.row].userPhoto), completed:nil)

        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = self.postDataList[indexPath.row].userName
        
        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.postDataList[indexPath.row].picture), completed:nil)

        
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
        // 選択したアイテムの元のバージョンのAssets Library URL
        let assetUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        
        let postVC = storyboard!.instantiateViewController(withIdentifier: "postView") as? PostViewController
        let _ = postVC?.view // ** hack code **
        self.postData.uploadPhotoImage = image
        self.postData.assetUrl = assetUrl
        postVC?.postData = self.postData
        postVC?.getPhotoMetaData()

        let navigationController = UINavigationController(rootViewController: postVC!)
        picker.present(navigationController, animated: true)
    }

    @objc func refresh(){
        fetchData()
        refreshControl.endRefreshing()
    }
    
    func fetchData() {
        self.postData = Post()
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
            self.postDataList = [Post]()
            for (_,post) in postsSnap!{
                self.postData = Post()

                if let uid = post["userId"] as? String, let date = post["createDate"] as? String,let picture = post["picture"] as? String{

                    self.postData.userId = uid
                    self.postData.fishingDate = date
                    self.postData.picture = picture

                    self.uid_Array.append(self.postData.userId)
                    self.date_Array.append(self.postData.fishingDate)
                    self.picture_Array.append(self.postData.picture)

                    ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let userSnap = snapshot.value as? NSDictionary

                        if userSnap == nil {
                            return
                        }
                        let userPhoto = userSnap?["userPhoto"] as! String
                        let userName = userSnap?["userName"] as! String
                        self.postData.userPhoto = userPhoto
                        self.postData.userName = userName

                        self.userPhoto_Array.append(self.postData.userPhoto)
                        self.userName_Array.append(self.postData.userName)

                        // プロフィール画像を取得したタイミングでtableViewリロード
                        self.tableView.reloadData()

                    })
                }
                self.postDataList.append(self.postData)
            }
        }
    }
}
