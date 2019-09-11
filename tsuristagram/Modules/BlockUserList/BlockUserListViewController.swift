//
//  BlockUserListViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class BlockUserListViewController: UIViewController {
    
    var presenter: BlockUserListViewPresenter!
    var userId: String!
    var user = User()

    var userList = [User]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.back))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80

        self.presenter.fetchUserData(userId: userId)
    }

    @objc func back() {
        presenter.back()
    }

    func setUser(user: User) {
        if user.blockUserList.count == 0 {
            tableView.setEmptyView(title: "ブロックしているユーザーはいません", message:  "")
        }
    }
    
    func setUserList(userList: [User]) {
        self.userList = userList
        UIView.setAnimationsEnabled(false)
        
        let currentDataCount = self.tableView.numberOfRows(inSection: 0)
        let newDataCount = currentDataCount + 1
        
        print("newDataCount: " + String(newDataCount))
        print("currentDataCount: " + String(currentDataCount))

        self.tableView.insertRows(
            at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) },
            with: .none)
        
        self.tableView.reloadRows(
            at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) },
            with: .none)

        UIView.setAnimationsEnabled(true)

    }

}

extension BlockUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let blockUserButton = cell.viewWithTag(1) as! UserSelectButton
        blockUserButton.userId = userList[indexPath.row].userId
        blockUserButton.userName = userList[indexPath.row].userName
        blockUserButton.setTitle(userList[indexPath.row].userName, for: .normal) // ボタンのタイトル
        blockUserButton.addTarget(self, action: #selector(selectUser(_:)), for: UIControl.Event.touchUpInside)

        let userPhoto = cell.viewWithTag(2) as! UIImageView
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width * 0.5
        userPhoto.clipsToBounds = true
        
        let userPhotoString = userList[indexPath.row].userPhoto
        userPhoto.sd_setImage(with: URL(string: userPhotoString), completed:nil)

        return cell
    }
    
    @objc func selectUser(_ sender: UserSelectButton) {
        // ブロック確認
        let title = "\(sender.userName)さんをブロックしますか？"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        let defaultAction_1: UIAlertAction = UIAlertAction(title: "ブロック解除", style: UIAlertAction.Style.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            
            // ブロック解除実施
            self.presenter.userUnBlock(userId: sender.userId)
            let title = "\(sender.userName)さんをブロック解除しました"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
            let defaultAction_1: UIAlertAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                // close
            })
            alert.addAction(defaultAction_1)
            self.present(alert, animated: true, completion: nil)
            
        })
        // ブロックキャンセル
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })
        
        alert.addAction(defaultAction_1)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
