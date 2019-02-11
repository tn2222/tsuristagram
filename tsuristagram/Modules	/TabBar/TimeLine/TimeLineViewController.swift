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

class TimeLineViewController: UIViewController {

    var presenter: TimeLineViewPresenter!

    @IBOutlet var tableView: UITableView!

    let refreshControl = UIRefreshControl()
    var timeLine = TimeLine()
    var post = Post()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.addSubview(refreshControl)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTimeLineData()
    }
    
    @IBAction func postButton(_ sender: Any) {
        presenter.postButton()
    }
    
    @objc func refresh() {
        fetchTimeLineData()
        refreshControl.endRefreshing()
    }
    
    // タイムラインデータのフェッチが完了したら呼び出される
    func setTimeLineData(timeLine: TimeLine) {
        self.timeLine = timeLine
        tableView.reloadData()
    }
    
    func fetchTimeLineData() {
        presenter.fetchTimeLineData()
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
        
//        let pointId = timeLine.postList[indexPath.row].pointId
        let userId = timeLine.postList[indexPath.row].userId
        let user = self.timeLine.userMap[userId]
        let userPhotoString = user!["userPhoto"] as! String
        let userName = user!["userName"] as! String
        
        let userPhoto = cell.viewWithTag(1) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        
        userPhoto.sd_setImage(with: URL(string: userPhotoString), completed:nil)
        
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = userName
        
        let pictureImage = cell.viewWithTag(3) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.timeLine.postList[indexPath.row].picture), completed:nil)

        let commentLabel = cell.viewWithTag(4) as! UILabel
        commentLabel.text = self.timeLine.postList[indexPath.row].comment

        let createDateLabel = cell.viewWithTag(5) as! UILabel
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(truncating: self.timeLine.postList[indexPath.row].timestamp))
        let dateString = Date.dateToString(date: date as Date, format: "yyyy/MM/dd HH:mm")

        createDateLabel.text = dateString

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // 下から５件くらいになったらリフレッシュ
//        guard tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)) != nil else { return }
//        // ここでリフレッシュのメソッドを呼ぶ
//        fetchTimeLineData()
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print("currentOffsetY: \(currentOffsetY)")
        print("maximumOffset: \(maximumOffset)")
        print("distanceToBottom: \(distanceToBottom)")
        if distanceToBottom < 500 {
//            fetchTimeLineData()
        }
    }

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

