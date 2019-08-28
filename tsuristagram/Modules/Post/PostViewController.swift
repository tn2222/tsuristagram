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

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var size: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var fishSpecies: UITextField!
    @IBOutlet var fishingDate: UITextField!
    @IBOutlet var comment: UITextView!
    @IBOutlet weak var pointName: UILabel!
    @IBOutlet var weather: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    
    var post = Post()
    var presenter: PostViewPresenter!
    var pointList = [Point]()  {
        didSet {
            setDataToTextField()
        }
    }

    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // settings navigation bar
        self.navigationItem.title = "釣果登録"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.postButton))

        comment.delegate = self
        // ロケーションマネージャー
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
        
        

        size.textAlignment = NSTextAlignment.right
        weight.textAlignment = NSTextAlignment.right
        fishSpecies.textAlignment = NSTextAlignment.right
        fishingDate.textAlignment = NSTextAlignment.right
        pointName.textAlignment = NSTextAlignment.right
        weather.textAlignment = NSTextAlignment.right
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataToTextField()
    }

    // textField to dataClass
    func setTextFiledToData() {
        post.size = size.text!
        post.weight = weight.text!
        post.fishSpecies = fishSpecies.text!
        post.fishingDate = fishingDate.text!
        post.comment = comment.text!
        post.pointName = pointName.text!
        post.weather = weather.text!
        post.uploadPhotoImage = uploadPhoto.image!
    }
    
    // dataClass to textField
    func setDataToTextField() {
        size.text = post.size
        weight.text = post.weight
        fishSpecies.text = post.fishSpecies
        fishingDate.text = post.fishingDate
        comment.text =  post.comment
        pointName.text = post.pointName
        weather.text = post.weather
        uploadPhoto.image = post.uploadPhotoImage

    }

    // firebaseにデータ登録
    @objc func postButton() {
        SVProgressHUD.show()
        setTextFiledToData()
        self.view?.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if (post.pointId.isEmpty) {
            post.pointId = "p9999"
        }
        presenter.postButton(post: self.post)
    }
    
    //写真アップロードをキャンセル。タイムラインページへ遷移
    @objc func cancel() {
        presenter.cancelButton()
    }

    // 釣り場検索画面へ遷移
    @IBAction func pointSearch(_ sender: Any) {
        presenter.pointSearchButton(pointList: self.pointList)
    }

    // 釣り場詳細画面へ遷移
    @IBAction func postLocation(_ sender: Any) {
        setTextFiledToData()
        presenter.pointLocationButton(latitude: self.post.latitude, longitude: self.post.longitude)
    }

    // 画面表示でフェッチした釣り場マスタを設定
    func setPointList(pointList: [Point]) {
        if pointList.count <= 0 { return }
        
        // 釣り場までの距離で降順ソートして、一番近い釣り場をセット
        var sortList = pointList
        sortList.sort(by: {$0.distance < $1.distance})
        post.pointName = sortList[0].name
        post.pointId = sortList[0].id

        self.pointList = pointList
    }
    
    // 釣り場検索画面で釣り場が選択された時に呼ばれる
    public func setPoint(id: String, name: String) {
        self.post.pointId = id
        self.post.pointName = name
    }

    // 釣り場詳細画面でロケーションが選択された時に呼ばれる
    public func setLocation(latitude: Double, longitude: Double) {
        self.post.latitude = latitude
        self.post.longitude = longitude
        
        print("select location!!")
        print(latitude)
        print(longitude)

        // 選択されたロケーションの緯度経度から距離を再計算する
        var pointListNew = [Point]()
        for point in pointList {
            var pointNew = Point()
            let distance = CommonUtils.distance(current: (la: latitude, lo: longitude), target: (la: point.latitude, lo: point.longitude))
            pointNew = point
            pointNew.distance = distance
            pointListNew.append(pointNew)
        }
        self.pointList = pointListNew
    }

}

extension PostViewController {
    // カメラロールから選択した写真のメタ情報を取得
    func getPhotoMetaData() {
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        //let result = PHAsset.fetchAssets(withALAssetURLs: [self.post.assetUrl], options: nil)
        //let result = self.post.assetUrl_ujgawa as! PHFetchResult<AnyObject>
        let asset = self.post.assetUrl_ujgawa
        
        var dateString = Date.currentTimeString(format: "yyyy/MM/dd HH:mm")
        self.fishingDate.text = dateString
        self.post.fishingDate = dateString

        // コンテンツ編集セッションを開始するためのアセットの要求
        (asset as AnyObject).requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            let url = contentEditingInput?.fullSizeImageURL
            let inputImage = CIImage(contentsOf: url!)!
            
            // Exif
            let exif = inputImage.properties["{Exif}"] as? Dictionary<String, Any>
            if exif != nil {
                // 撮影日
                let dateTimeOriginal = exif!["DateTimeOriginal"] as? String
                if dateTimeOriginal != nil {
                    let dateTime = Date.stringToDate(string: dateTimeOriginal!, format: "yyyy:MM:dd HH:mm:ss")
                    dateString = Date.dateToString(date: dateTime, format: "yyyy/MM/dd HH:mm")
                }
            }
            self.fishingDate.text = dateString
            self.post.fishingDate = dateString
            
            // 位置情報
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            let gps = inputImage.properties["{GPS}"] as? Dictionary<String,Any>
            if gps != nil {
                if gps!["Latitude"] as? Double != nil {
                    latitude = gps!["Latitude"] as! Double
                    if gps!["LatitudeRef"] as? String != nil {
                        let latitudeRef = gps!["LatitudeRef"] as! String
                        if latitudeRef == "S" {
                            latitude = latitude * -1
                        }
                    }
                }
                if gps!["Longitude"] as? Double != nil {
                    longitude = gps!["Longitude"] as! Double
                    if gps!["LongitudeRef"] as? String != nil {
                        let longitudeRef = gps!["LongitudeRef"] as! String
                        if longitudeRef == "W" {
                            longitude = longitude * -1
                        }
                    }
                }
            }

            print("photo select!!")
            print(latitude)
            print(longitude)

            self.post.latitude = latitude
            self.post.longitude = longitude
            self.presenter.fetchPointData(latitude: latitude, longitude: longitude)
        })

        // ビューに表示する
        self.uploadPhoto.image = self.post.uploadPhotoImage
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 入力を反映させたテキストを取得する
        let resultText: String = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        if resultText.count <= 128 {
            return true
        }
        return false
    }

}
