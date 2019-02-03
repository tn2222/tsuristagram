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
    var presenter: PostPointSearchPresenter!
    var pointList = [Point]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        // 遷移先viewController
        let postVC = storyboard!.instantiateViewController(withIdentifier: "postView") as? PostViewController
        let router = PostPointSearchRouterImpl(postPointSearchViewController: self, postViewController: postVC!)
        let interactor = PostPointSearchInteractorImpl()
        self.presenter = PostPointSearchPresenterImpl(post: post,view: self, router: router,interactor: interactor)
        interactor.delegate = self.presenter as? PostPointSearchInteractorDelegate

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

    @IBAction func backButton(_ sender: Any) {
        presenter.backButton()
    }
    
    func fetchPointData() {
        presenter.fetchPointData()
    }
}
