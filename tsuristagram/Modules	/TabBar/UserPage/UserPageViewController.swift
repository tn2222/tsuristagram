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

    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.fetchUserData(userId: userId)

    }

    func setUser(user: User) {
        print(user)
    }
}
