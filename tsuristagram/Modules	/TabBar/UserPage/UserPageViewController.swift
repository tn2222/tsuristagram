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
    var fetchEndWorkItem: DispatchWorkItem!

    var postList = [Post]() {
        didSet {
            if (fetchEndWorkItem != nil){
                fetchEndWorkItem.cancel()
            }
            finishLoading()
        }
    }
    var userId: String!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var postCount: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userImageExpand: UILabel!
    @IBOutlet var userSetting: UIButton!
    
    
    
    @IBAction func userSettingButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 123, height: 100)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
        
        self.presenter.fetchUserData(userId: userId)
        self.presenter.fetchData(userId: userId)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func finishLoading() {
        fetchEndWorkItem = DispatchWorkItem() {
            self.postCount.text = String(self.postList.count)
            self.loadPostData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: fetchEndWorkItem)
        
    }
    // 画面表示でフェッチした投稿データを設定
    func setPostList(postList: [Post]) {
        if postList.count <= 0 { return }
        self.postList = postList
    }


    func setUser(user: User) {
        print(user)
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

}
