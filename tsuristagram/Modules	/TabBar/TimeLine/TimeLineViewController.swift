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
import YPImagePicker



class TimeLineViewController: UIViewController {

    var presenter: TimeLineViewPresenter!

    @IBOutlet var tableView: UITableView!

    let refreshControl = UIRefreshControl()
    var timeLine = TimeLine()
    var post = Post()
    
    var activityIndicator: UIActivityIndicatorView!

    private var tableState: TableControllerState = .Initialize

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

        // ActivityIndicatorを作成＆中央に配置
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
                
        presenter.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func selectUser(_ sender: UserSelectButton) {
        presenter.selectUser(userId: sender.userId)

    }

    @IBAction func postButton(_ sender: Any) {
        presenter.postButton()
    }
    
    @objc func refresh() {
        fetchTimeLineData()
        refreshControl.endRefreshing()
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
            self.activityIndicator.stopAnimating()
            
            if isComplate {
                self.tableState = .Complate
            } else {
                self.tableState = .Normal
            }
            
            
        }
    }
    
    func fetchTimeLineData() {
        guard tableState == .Normal else { return }
        tableState = .Fetching
        presenter.fetchTimeLineData()
    }
    
    func loadMore() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("add load now!")
            self.presenter.fetchTimeLineData()
        }
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
        
        let userId = timeLine.postList[indexPath.row].userId
        let user = self.timeLine.userMap[userId]
        let userPhotoString = user!.userPhoto
        let userName = user!.userName
        
        let userPhoto = cell.viewWithTag(1) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        
        userPhoto.sd_setImage(with: URL(string: userPhotoString), completed:nil)
        
        let userNameButton = cell.viewWithTag(2) as! UserSelectButton
        userNameButton.userId = userId
        userNameButton.setTitle(userName, for: .normal) // ボタンのタイトル
        userNameButton.addTarget(self, action: #selector(selectUser(_:)), for: UIControl.Event.touchUpInside)

        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.timeLine.postList[indexPath.row].picture), completed:nil)

        let commentLabel = cell.viewWithTag(4) as! UILabel
        commentLabel.text = self.timeLine.postList[indexPath.row].comment

        let createDateLabel = cell.viewWithTag(5) as! UILabel
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: (-1) * Int(truncating: self.timeLine.postList[indexPath.row].timestamp))))

        let dateString = Date.dateToString(date: date as Date, format: "yyyy/MM/dd HH:mm")

        createDateLabel.text = dateString

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
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

//    // cellが選択された場合
//    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let userId = timeLine.postList[indexPath.row].userId
//        presenter.didSelectRowAt(userId: userId)
//    }

}

extension TimeLineViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        
        // 選択した写真を取得する
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // 選択したアイテムの元のバージョンのAssets Library URL
        let assetUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        
        let postVC = PostRouter.assembleModules() as! PostViewController
        
        let _ = postVC.view // ** hack code **
        self.post.uploadPhotoImage = image
        self.post.assetUrl = assetUrl
        postVC.post = self.post
        postVC.getPhotoMetaData()
        
        let navigationController = UINavigationController(rootViewController: postVC)
        picker.present(navigationController, animated: true)
    }

}
