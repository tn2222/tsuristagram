//
//  PostPointSeachViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostPointSearchViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var searchBar: UISearchBar!

    var presenter: PostPointSearchViewPresentable!
    var pointListAll = [Point]()
    var pointList = [Point]() {
        didSet {
            // 距離で降順ソート
            pointList.sort(by: {$0.distance < $1.distance})
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        //SearchBar作成
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.size.width, height: 44)
        searchBar.showsCancelButton = true

        tableView.tableHeaderView = searchBar
        
        if pointListAll.count <= 0 {
            presenter.fetchPointData(presentLatitude: CommonUtils.getPresentLatitude(), presentLongitude: CommonUtils.getPresentLongitude())
        }
        pointList = pointListAll
    }

    // 画面表示でフェッチした釣り場マスタを設定
    func setPointList(pointList: [Point]) {
        if pointList.count <= 0 { return }
        self.pointList = pointList
        self.pointListAll = pointList
    }

}

// searchBar
extension PostPointSearchViewController: UISearchBarDelegate {
    
    // 虫眼鏡が押されたら呼ばれる
    @objc func rightBarBtnClicked(sender: UIButton){
        tableView.contentOffset = CGPoint(x: 0,y :0)
    }

    // キャンセル押下
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        pointList = pointListAll
    }

    //要素を検索
    func searchItems(searchText: String) {
        if searchText != "" {
            pointList = pointListAll.filter { point in
                // 英数字は半角に変換してからcontaints
                let text = searchText.transformFullwidthHalfwidth()
                let name = point.name.transformFullwidthHalfwidth()
                let address = point.address.transformFullwidthHalfwidth()
                return name.contains(text) || address.contains(text)
            }
        } else {
            pointList = pointListAll
        }
    }
    
    //テキストが変更される毎に呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems(searchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchItems(searchText: searchBar.text! as String)
    }
}

// tableView
extension PostPointSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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

        let pointDistance = cell.viewWithTag(3) as! UILabel
        if self.pointList[indexPath.row].positionGetFlag == true {
            if self.pointList[indexPath.row].id == "p9999" {
                pointDistance.text = " - km"
            } else {
                pointDistance.text = String(self.pointList[indexPath.row].distance) + "km"
            }
        } else {
            pointDistance.text = ""
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // cellが選択された場合
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < pointList.count else { return }
        let point = pointList[indexPath.row]
        
        presenter.didSelectRow(point: point)
    }
}
