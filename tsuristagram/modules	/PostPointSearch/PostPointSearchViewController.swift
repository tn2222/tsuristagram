//
//  PostPointSeachViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostPointSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var post = Post()
    var presenter: PostPointSearchViewPresenter!
    var pointList = [Point](){
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPointData()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let pointName = cell.viewWithTag(1) as! UILabel
        pointName.text = self.pointList[indexPath.row].name

        let pointAddress = cell.viewWithTag(2) as! UILabel
        pointAddress.text = self.pointList[indexPath.row].address

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    // cellが選択された場合
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
    @IBAction func backButton(_ sender: Any) {
        presenter.backButton()
    }
    
    // 釣り場マスタ取得
    func fetchPointData() {
        presenter.fetchPointData()
    }
    
    // 画面リロード
    func reloadData(pointList: [Point]) {
        self.pointList = pointList
    }
}

