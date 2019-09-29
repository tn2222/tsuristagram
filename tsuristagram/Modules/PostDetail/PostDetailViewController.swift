//
//  PostDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMaps

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var pointIcon: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var pointNameButton: PointSelectButton!    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var size: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var fishSpecies: UILabel!
    @IBOutlet var pointName: UILabel!
    @IBOutlet var fishingDate: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var likeButton: LikeButton!
    @IBOutlet var likeCountLabel: UILabel!
    
    var presenter: PostDetailViewPresenter!
    var postKey: String!
    var userId: String!
    var post = Post()
    var point = Point()
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()
    private var nextViewFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ポイントのアイコンとマップをロードが完了するまで非表示
        pointIcon.isHidden = true
        mapView.isHidden = true
        likeButton.isEnabled = false
        
        // 削除ボタン有無判定
        if CommonUtils.getUserId() == userId {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "infomartion.png")?.withRenderingMode(.alwaysOriginal),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.settings))

        }
        
        // imageをダブルタップされた時にいいねをする
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLikeButton(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        picture.addGestureRecognizer(doubleTapGesture)
        doubleTapGesture.delegate = self
        picture.isHidden = true
        
        self.presenter.fetchData(postKey: postKey)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.mapView != nil && !nextViewFlag {
            self.mapView.clear()
            self.mapView.removeFromSuperview()
        }
        if nextViewFlag {
            nextViewFlag = false
        }
    }

    @objc func settings() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let action1 = UIAlertAction(title: "編集", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.nextViewFlag = true
            self.presenter.presentEditView(post: self.post)
        })
        
        
        let action2 = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            // ブロック確認
            let title = "この投稿を削除しますか？"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
            let defaultAction_1: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{
                (action: UIAlertAction!) -> Void in
                // ブロック実施
                self.deleteButton()
            })
            // キャンセル
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("cancelAction")
            })
            
            alert.addAction(defaultAction_1)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)

    }

    @IBAction func userButton(_ sender: Any) {
        nextViewFlag = true
        presenter.userButton(userId: post.userId)
    }
    
    @IBAction func pointButton(_ sender: Any) {
        nextViewFlag = true
        presenter.pointButton(point: point)
    }
    
    @IBAction func pointLocationButton(_ sender: Any) {
        nextViewFlag = true
        presenter.pointLocationButton(latitude: post.latitude, longitude: post.longitude)
    }
    
    
    @IBAction func didTapLikeButton(_ sender: LikeButton) {
        likeButton.isEnabled = false
        if post.likesFlag {
            // dislike
            post.likesFlag = false
            post.likesCount -= 1
            if post.likesCount > 0 {
                likeCountLabel.text = String(post.likesCount)
            } else {
                likeCountLabel.text = ""
            }
            let dislike:UIImage = UIImage(named:"dislike")!
            likeButton.setImage(dislike, for: .normal)
            presenter.disLike(likeButton: likeButton)
        } else {
            // like
            post.likesFlag = true
            post.likesCount += 1
            likeCountLabel.text = String(post.likesCount)
            let like:UIImage = UIImage(named:"like")!
            likeButton.setImage(like, for: .normal)
            presenter.like(likeButton: likeButton)
        }
        
        // TimeLineViewControllerに変更を通知
        var postDic:[String: String] = ["postKey": post.key]
        postDic.updateValue(String(post.likesFlag), forKey: "isLike")
        postDic.updateValue(String(post.likesCount), forKey: "likesCount")
        NotificationCenter.default.post(name: .notifyName, object: nil, userInfo: postDic)

    }

    // firebaseからデータ削除
    @objc func deleteButton() {
        SVProgressHUD.show()
        self.view?.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let uiview = UIView()
        uiview.backgroundColor = UIColor.lightGray
        uiview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        uiview.alpha = 0.3
        self.tabBarController?.view.addSubview(uiview)
        presenter.deleteButton(post: post)
    }

    func setUser(user: User) {
        userName.text = user.userName
        
        userImage.layer.cornerRadius = userImage.frame.size.width * 0.5
        userImage.clipsToBounds = true
        userImage.sd_setImage(with: URL(string: user.userPhoto), completed:nil)
        picture.sd_setImage(with: URL(string: post.picture), completed:nil)
        post.uploadPhotoImage = picture.image!
        picture.isHidden = false

        // like
        likeButton.postKey = post.key
        if post.likesFlag {
            let like:UIImage = UIImage(named:"like")!
            likeButton.setImage(like, for: .normal)
        }
        if post.likesCount > 0 {
            likeCountLabel.text = String(post.likesCount)
        } else {
            likeCountLabel.text = ""
        }

        if post.size.count > 0 {
            size.text = String(post.size) + "cm"
        } else {
            size.text = post.size
        }
        if post.weight.count > 0 {
            weight.text = String(post.weight) + "g"
        } else {
            weight.text = post.weight
        }

        fishSpecies.text = post.fishSpecies
        
        weather.text = post.weather
        fishingDate.text = post.fishingDate
        
        //表示可能最大行数を指定
        comment.numberOfLines = 20
        //contentsのサイズに合わせてobjectのサイズを変える
        comment.text = post.comment
        comment.numberOfLines = 0
        comment.sizeToFit()
        comment.frame.size.height = comment.frame.height
        //単語の途中で改行されないようにする
        comment.lineBreakMode = .byWordWrapping
        scrollView.contentSize.height = comment.frame.maxY + 200

        pointIcon.isHidden = false

    }

    func setPostData(post: Post) {
        self.post = post
        likeButton.isEnabled = true
        setMapView(latitude: post.latitude, longitude: post.longitude)
    }
    
    func setPoint(point: Point) {
        self.point = point
        post.pointName = point.name
        post.pointId = point.id

        pointName.text = point.name
        pointNameButton.setTitle(point.name, for: .normal)
        if mapView != nil {
            mapView.isHidden = false
        }
    }

    func setLikeButton(likeButton: LikeButton) {
        likeButton.isEnabled = true
    }

    func setMapView(latitude: Double, longitude: Double) {
        var camera: GMSCameraPosition
        
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

}
