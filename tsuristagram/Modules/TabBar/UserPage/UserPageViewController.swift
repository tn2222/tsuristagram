//
//  UserPageViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {
    
    var presenter: UserPageViewPresenter!
    var point: Point!
    var fetchComplateWorkItem: DispatchWorkItem!

    var postList = [Post]() {
        didSet {
            if (fetchComplateWorkItem != nil){
                fetchComplateWorkItem.cancel()
            }
            finishLoading()
        }
    }
    var userId: String!
    
    @IBOutlet var collectionView: UICollectionView!
    var postCount: String!
    var userName: String!
    var userPhotoString: String!
    var userImage: UIImageView!
    var userImageExpand: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "FishTips"

        collectionView.dataSource = self
        collectionView.delegate = self
        
//        startIndicator()

        // ユーザ設定ボタン有無判定
        if userId == nil {
            userId = CommonUtils.getUserId()
        }
        if CommonUtils.getUserId() == userId {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "infomartion.png")?.withRenderingMode(.alwaysOriginal),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.editButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "infomartion.png")?.withRenderingMode(.alwaysOriginal),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.displayAlert))
        }
  
        // レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 300)

        if self.view.bounds.width < 600 {
            layout.itemSize = CGSize(width:self.view.frame.size.width / 3 - 2, height:self.view.frame.size.width / 3 - 2)
        } else {
            layout.itemSize = CGSize(width:self.view.frame.size.width / 6 - 2, height:self.view.frame.size.width / 6 - 2)
        }
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout

        self.presenter.fetchUserData(userId: userId)
        self.presenter.fetchData(userId: userId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // ユーザ設定画面遷移
    @objc func editButton() {
        presenter.editButton(userId: userId)
    }

    @objc func displayAlert() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let action1 = UIAlertAction(title: "ブロック", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            // ブロック確認
            let title = "\(self.userName!)さんをブロックしますか？"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
            let defaultAction_1: UIAlertAction = UIAlertAction(title: "ブロック", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
                // ブロック実施
                self.presenter.userBlock(userId: self.userId)
                let title = "\(self.userName!)さんをブロックしました"
                let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
                let defaultAction_1: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    // close
                })
                alert.addAction(defaultAction_1)
                self.present(alert, animated: true, completion: nil)

            })
            // ブロックキャンセル
            let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("cancelAction")
            })

            alert.addAction(defaultAction_1)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)

        })
        
        let action2 = UIAlertAction(title: "報告する", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let defaultAction_1: UIAlertAction = UIAlertAction(title: "スパムである", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.presenter.report(reportType: 1, userId: self.userId)
                
                let title = "報告しました"
                let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
                let defaultAction_1: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    // close
                })
                alert.addAction(defaultAction_1)
                self.present(alert, animated: true, completion: nil)

            })
            let defaultAction_2: UIAlertAction = UIAlertAction(title: "不適切である", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.presenter.report(reportType: 2, userId: self.userId)
                
                let title = "報告しました"
                let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
                let defaultAction_1: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    // close
                })
                alert.addAction(defaultAction_1)
                self.present(alert, animated: true, completion: nil)

            })

            // キャンセル
            let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("cancelAction")
            })
            
            actionSheet.addAction(defaultAction_1)
            actionSheet.addAction(defaultAction_2)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func finishLoading() {
        
        fetchComplateWorkItem = DispatchWorkItem() {
            self.postCount = String(self.postList.count)
            self.collectionView.reloadData()
            self.loadPostData()
//            self.dismissIndicator()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: self.fetchComplateWorkItem)
        
    }
    // 画面表示でフェッチした投稿データを設定
    func setPostList(postList: [Post]) {
        if postList.count <= 0 { return }
        self.postList = postList
    }


    func setUser(user: User) {
        
        userName = user.userName
        userPhotoString = user.userPhoto
        
        collectionView.reloadData()
    }
    
    func loadPostData() {
        
        UIView.setAnimationsEnabled(false)
        
        let newDataCount = self.postList.count
        let currentDataCount = self.collectionView.numberOfItems(inSection: 0)
        
        print("newDataCount: " + String(newDataCount))
        print("currentDataCount: " + String(currentDataCount))

        self.collectionView.insertItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })

        self.collectionView.reloadItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })
        
        UIView.setAnimationsEnabled(true)
        
    }
}


extension UserPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let pictureImage = cell.viewWithTag(1) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.postList[indexPath.row].picture), completed:nil)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let post = postList[indexPath.row]
        
        presenter.selectCell(post: post)
        
        return true
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserPageHeader", for: indexPath) as? UserPageHeader else {
            fatalError("Could not find proper header")
        }
        
        if kind == UICollectionView.elementKindSectionHeader {

            header.postCount.text = postCount
            header.userName.text = userName
            header.userImage.layer.cornerRadius = header.userImage.frame.size.width * 0.5
            header.userImage.clipsToBounds = true
            if userPhotoString != nil {
                header.userImage.sd_setImage(with: URL(string: userPhotoString), completed:nil)
                header.userImageExpand.sd_setImage(with: URL(string: userPhotoString), completed:nil)
            }
            return header
        }
        
        return UICollectionReusableView()
    }
}
