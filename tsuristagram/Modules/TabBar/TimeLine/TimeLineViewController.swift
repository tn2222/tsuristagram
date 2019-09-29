//
//  TimeLineViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SVProgressHUD

class TimeLineViewController: UIViewController, CLLocationManagerDelegate {

    var presenter: TimeLineViewPresenter!

    @IBOutlet var tableView: UITableView!

    let refreshControl = UIRefreshControl()
    var timeLine = TimeLine()
    var post = Post()
    // <postKey, like or disLike>
    var likesMap : Dictionary<String, LikeInfo> = [:]

//    var activityIndicator: UIActivityIndicatorView!

    private var tableState: TableControllerState = .Initialize

    var locationManager: CLLocationManager!
    var presentLatitude: Double!
    var presentLongitude: Double!

    enum TableControllerState {
        case Initialize
        case Normal
        case Fetching
        case Complate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "FishTips"

        // 現在地取得
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            UserDefaults.standard.set(0.0, forKey: "presentLatitude")
            UserDefaults.standard.set(0.0, forKey: "presentLongitude")
        } else {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyPostData(_:)),
                                               name: .notifyName,
                                               object: nil)

        SVProgressHUD.show()
        presenter.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.delegate = self
        self.tabBarController?.tabBar.isHidden = false
    }

    @objc func notifyPostData(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            let key = dict["postKey"] as! String
            let isLike = dict["isLike"] as! String
            let likesCount = dict["likesCount"] as! String
            if likesMap[key] != nil {
                var likeInfo = likesMap[key]
                likeInfo!.isLike = Bool(isLike)!
                
                // likes count
                if Int(likesCount)! > 0 {
                    likeInfo?.likeButton.likeCountLabel.text = likesCount
                } else {
                    likeInfo?.likeButton.likeCountLabel.text = ""
                }
                
                // like image
                if likeInfo!.isLike {
                    let like:UIImage = UIImage(named:"like")!
                    likeInfo?.likeButton.setImage(like, for: .normal)
                } else {
                    let dislike:UIImage = UIImage(named:"dislike")!
                    likeInfo?.likeButton.setImage(dislike, for: .normal)
                }
            }
        }
    }

    func changeLikeStatus(likeInfo: LikeInfo) {
        
    }

    @IBAction func didTapLikeButton(_ sender: LikeButton) {
        sender.isEnabled = false
        if likesMap[sender.postKey]!.isLike {
            // dislike
            likesMap[sender.postKey]!.isLike = false
            timeLine.postList[sender.rowNum].likesCount -= 1
            if timeLine.postList[sender.rowNum].likesCount > 0 {
                sender.likeCountLabel.text = String(timeLine.postList[sender.rowNum].likesCount)
            } else {
                sender.likeCountLabel.text = ""
            }
            let dislike:UIImage = UIImage(named:"dislike")!
            sender.setImage(dislike, for: .normal)
            presenter.disLike(likeButton: sender)
        } else {
            // like
            likesMap[sender.postKey]!.isLike = true
            timeLine.postList[sender.rowNum].likesCount += 1
            sender.likeCountLabel.text = String(timeLine.postList[sender.rowNum].likesCount)
            let like:UIImage = UIImage(named:"like")!
            sender.setImage(like, for: .normal)
            presenter.like(likeButton: sender)
        }
    }
    
    @objc func selectUser(_ sender: UserSelectButton) {
        presenter.selectUser(userId: sender.userId)
    }

    @objc func selectPost(_ sender: PostSelectButton) {
        presenter.selectPost(postKey: sender.postKey, userId: sender.userId)
    }

    @objc func selectPoint(_ sender: PointSelectButton) {
        presenter.selectPoint(point: sender.point)
    }

    @IBAction func postButton(_ sender: Any) {
        presenter.postButton()
    }
    
    @objc func refresh() {
        fetchTimeLineData()
        refreshControl.endRefreshing()
    }
    
    func initialize() {
        timeLine = TimeLine()
        presenter.timeLine = TimeLine()
        presenter.resetFetchOffset()
        tableView.reloadData()
        presenter.initialize()
    }
    // initializeが完了したら呼び出される
    func initializeComplate() {
        tableState = .Normal
        fetchTimeLineData()
    }

    func setLikeButton(likeButton: LikeButton) {
        likeButton.isEnabled = true
    }

    // タイムラインデータのフェッチが完了したら呼び出される
    func complateFetchTimeLineData(timeLine: TimeLine, isComplate: Bool) {
        self.timeLine = timeLine
        
        DispatchQueue.main.async {

            UIView.setAnimationsEnabled(false)
            
            let newDataCount = self.timeLine.postList.count
            let currentDataCount = self.tableView.numberOfRows(inSection: 0)
            
            print("newDataCount: " + String(newDataCount))
            print("currentDataCount: " + String(currentDataCount))

            self.tableView.insertRows(
                at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) },
                with: .none)

            self.tableView.reloadRows(
                at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) },
                with: .none)
            
            UIView.setAnimationsEnabled(true)
            SVProgressHUD.dismiss()

            if isComplate {
                self.tableState = .Complate
            } else {
                self.tableState = .Normal
            }

            SVProgressHUD.dismiss()
        }
    }
    
    func fetchTimeLineData() {
        guard tableState == .Normal else { return }
        tableState = .Fetching
        presenter.fetchTimeLineData()
    }
    
    func loadMore() {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("add load now!")
            self.presenter.fetchTimeLineData()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        presentLatitude = location?.coordinate.latitude
        presentLongitude = location?.coordinate.longitude
        
        UserDefaults.standard.set(presentLatitude, forKey: "presentLatitude")
        UserDefaults.standard.set(presentLongitude, forKey: "presentLongitude")
        
        print("latitude: \(presentLatitude!)\nlongitude: \(presentLongitude!)")
    }

}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLine.postList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // cell選択時のカラー
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = cellSelectedBgView
        
        // userData
        let userId = timeLine.postList[indexPath.row].userId
        let user = self.timeLine.userMap[userId]
        let userPhotoString = user!.userPhoto
        let userName = user!.userName
        
        // pointData
        let pointId = timeLine.postList[indexPath.row].pointId
        let point = self.timeLine.pointMap[pointId]

        let likeCount = cell.viewWithTag(11) as! UILabel
        likeCount.text = ""
        if self.timeLine.postList[indexPath.row].likesCount > 0 {
            likeCount.text = String(self.timeLine.postList[indexPath.row].likesCount)
        }

        // like button
        let likeButton = cell.viewWithTag(10) as! LikeButton
        likeButton.postKey = self.timeLine.postList[indexPath.row].key
        likeButton.rowNum = indexPath.row
        likeButton.likeCountLabel = likeCount
        if likesMap[self.timeLine.postList[indexPath.row].key]!.isLike {
            let like:UIImage = UIImage(named:"like")!
            likeButton.setImage(like, for: .normal)
        } else {
            let dislike:UIImage = UIImage(named:"dislike")!
            likeButton.setImage(dislike, for: .normal)
        }
        likesMap[likeButton.postKey]?.likeButton = likeButton
        
        let userPhoto = cell.viewWithTag(1) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        
        userPhoto.sd_setImage(with: URL(string: userPhotoString), completed:nil)
        
        let pointLabel = cell.viewWithTag(6) as! UILabel
        pointLabel.text = userName
        
        let userNameButton = cell.viewWithTag(2) as! UserSelectButton
        userNameButton.userId = userId
        userNameButton.addTarget(self, action: #selector(selectUser(_:)), for: UIControl.Event.touchUpInside)

        let pointSelectButton = cell.viewWithTag(7) as! PointSelectButton
        pointSelectButton.point = point!
        pointSelectButton.setTitle(point?.name, for: .normal) // ボタンのタイトル
        pointSelectButton.addTarget(self, action: #selector(selectPoint(_:)), for: UIControl.Event.touchUpInside)

        let postSelectButton = cell.viewWithTag(8) as! PostSelectButton
        postSelectButton.isEnabled = false
        postSelectButton.postKey = self.timeLine.postList[indexPath.row].key
        postSelectButton.userId = userId
        postSelectButton.addTarget(self, action: #selector(selectPost(_:)), for: UIControl.Event.touchUpInside)

        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.timeLine.postList[indexPath.row].picture),completed: { (image, err, cacheType, url) in
            // 画像セットが完了したら投稿詳細へ遷移するボタンを活性化
            postSelectButton.isEnabled = true
            })

        let commentLabel = cell.viewWithTag(4) as! UILabel
        
        // コメントがなければ定型文表示
        if timeLine.postList[indexPath.row].comment.isEmpty {
            // 魚種があれば魚種出力
            if !timeLine.postList[indexPath.row].fishSpecies.isEmpty {
                // 魚種が入力されているかつ、サイズ入力されている場合は、サイズと魚種を出力
                if !timeLine.postList[indexPath.row].size.isEmpty {
                    commentLabel.text = "\(user!.userName) さんが \(point!.name) で\(timeLine.postList[indexPath.row].size)cmの\(timeLine.postList[indexPath.row].fishSpecies)を釣り上げました！ おめでとうございます！！"
                } else {
                    commentLabel.text = "\(user!.userName) さんが \(point!.name) で\(timeLine.postList[indexPath.row].fishSpecies)を釣り上げました！ おめでとうございます！！"
                }
            } else {
                commentLabel.text = "\(user!.userName) さんが \(point!.name) で釣り上げました！ おめでとうございます！！"
            }
        } else {
            // コメントがあればコメントを表示
            commentLabel.text = self.timeLine.postList[indexPath.row].comment
        }
        
        let createDateLabel = cell.viewWithTag(5) as! UILabel
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: (-1) * Int(truncating: self.timeLine.postList[indexPath.row].timestamp))))

        let dateString = Date.dateToString(date: date as Date, format: "yyyy/MM/dd HH:mm")

        createDateLabel.text = dateString

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if case .Complate = tableState {
            return
        }
        
        if (self.tableView.contentOffset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging && tableState == .Normal) {
            
            print(self.tableView.contentOffset.y)
            tableState = .Fetching
            self.loadMore()
        }
    }

}

extension TimeLineViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            // 一番上に移動
            let statusBar = UIApplication.shared.statusBarFrame.height
            let navBar = self.navigationController!.navigationBar.frame.size.height
            let offset = CGPoint(x:0,y:(navBar + statusBar) * -1)
            self.tableView.setContentOffset(offset, animated: true)
        }
    }
}
