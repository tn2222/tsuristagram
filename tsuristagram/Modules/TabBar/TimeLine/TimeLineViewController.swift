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
        
        SVProgressHUD.show()
        presenter.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.delegate = self
        self.tabBarController?.tabBar.isHidden = false
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
        postSelectButton.postKey = self.timeLine.postList[indexPath.row].key
        postSelectButton.userId = userId
        postSelectButton.addTarget(self, action: #selector(selectPost(_:)), for: UIControl.Event.touchUpInside)

        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.timeLine.postList[indexPath.row].picture), completed:nil)

        let commentLabel = cell.viewWithTag(4) as! UILabel
        
        //Below is Yosuke Ujigawa adding cood..
        if timeLine.postList[indexPath.row].comment.isEmpty {
            commentLabel.text = "\(user!.userName) さんが \(point!.name) で釣り上げました！ おめでとうございます！！"
        }else{
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
