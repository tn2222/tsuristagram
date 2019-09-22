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
import GoogleMaps

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var size: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var fishSpecies: UITextField!
    @IBOutlet var fishingDate: UITextField!
    @IBOutlet weak var pointName: UILabel!
    @IBOutlet var weather: UITextField!
    @IBOutlet var uploadPhoto: UIImageView!
    @IBOutlet var comment: InspectableTextView!
    
    @IBOutlet weak var mapView: GMSMapView!
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()
    // mapViewを設定するかどうかのフラグ
    var showMapViewFlag: Bool!
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.postButton))

        hideKeyboardWhenTappedAround()

        // placeholder
        size.placeholder = "サイズ"
        weight.placeholder = "重さ"
        fishSpecies.placeholder = "魚種"
        fishingDate.placeholder = "日付"
        weather.placeholder = "天気"

        // alignment
        size.textAlignment = NSTextAlignment.left
        weight.textAlignment = NSTextAlignment.left
        fishSpecies.textAlignment = NSTextAlignment.left
        fishingDate.textAlignment = NSTextAlignment.left
        pointName.textAlignment = NSTextAlignment.left
        weather.textAlignment = NSTextAlignment.left
        
        //keyboardType
        size.keyboardType = UIKeyboardType.numberPad
        weight.keyboardType = UIKeyboardType.numberPad
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showMapViewFlag == true {
            setMapView()
        }
        setDataToTextField()
    }

    //写真アップロードをキャンセル。タイムラインページへ遷移
    @objc func cancel() {
        presenter.cancelButton()
        clearMapView()
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
        clearMapView()
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
        comment.awakeFromNib()
        pointName.text = post.pointName
        weather.text = post.weather
        uploadPhoto.image = post.uploadPhotoImage

    }

    func setMapView() {
        var camera: GMSCameraPosition
        let latitude = self.post.latitude
        let longitude = self.post.longitude
        
        // 写真の緯度経度が取れない場合
        if latitude == 0 && longitude == 0 {
            // 現在地が取得できた場合は現在地付近を表示
            if CommonUtils.getPresentLatitude() != 0 && CommonUtils.getPresentLongitude() != 0 {
                camera = GMSCameraPosition.camera(withLatitude: CommonUtils.getPresentLatitude(),
                                                  longitude: CommonUtils.getPresentLongitude(),
                                                  zoom: 15)
            } else {
                // 現在地が取得できない場合は、定点（東京）
                camera = GMSCameraPosition.camera(withLatitude: 35.7020691,
                                                  longitude: 139.7753269,
                                                  zoom: 15)
            }
        } else {
            // 写真の緯度経度が取得できた場合
            camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 15)
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        mapView.camera = camera
        self.marker.map = mapView
        self.position = marker.position
    }

    func clearMapView() {
        if self.mapView != nil {
            self.mapView.clear()
            self.mapView.removeFromSuperview()
        }
    }
    
    // 画面表示でフェッチした釣り場マスタを設定
    func setPointList(pointList: [Point]) {
        if pointList.count <= 0 { return }
        
        if pointList[0].positionGetFlag == false {
            // 写真から緯度経度が取れない場合は、不明な釣り場をセット
            post.pointName = "不明な釣り場"
            post.pointId = "p9999"
        } else {
            // 釣り場までの距離で降順ソートして、一番近い釣り場をセット
            var sortList = pointList
            sortList.sort(by: {$0.distance < $1.distance})
            
            // 一番近い釣り場が10km以上離れている場合は、不明な釣り場をセット
            if sortList[0].distance == 10 {
                post.pointName = "不明な釣り場"
                post.pointId = "p9999"
            } else {
                post.pointName = sortList[0].name
                post.pointId = sortList[0].id
            }
        }
        
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
        let asset = self.post.asset
        
        var dateString = Date.currentTimeString(format: "yyyy/MM/dd HH:mm")
        self.fishingDate.text = dateString
        self.post.fishingDate = dateString

        self.post.latitude = CommonUtils.getPresentLatitude()
        self.post.longitude = CommonUtils.getPresentLongitude()

        // コンテンツ編集セッションを開始するためのアセットの要求
        (asset as AnyObject).requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            let url = contentEditingInput?.fullSizeImageURL
            if url != nil {
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
                
                if latitude == 0 && longitude == 0 {
                    self.post.latitude = CommonUtils.getPresentLatitude()
                    self.post.longitude = CommonUtils.getPresentLongitude()
                } else {
                    self.post.latitude = latitude
                    self.post.longitude = longitude

                }
            }
            // 釣り場詳細のマップビュー表示
            self.setMapView()
            self.showMapViewFlag = true
            self.presenter.fetchPointData(latitude: self.post.latitude, longitude: self.post.longitude)
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
