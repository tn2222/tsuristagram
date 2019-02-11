//
//  MainTabBarViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/09.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tabbar作成
        var viewControllers: [UIViewController] = []
        
        let view = TimeLineRouter.assembleModules()
        
        view.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.mostRecent, tag: 0)
//       view.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tabbar_home_disable"), tag: 0)
        viewControllers.append(view)

        self.viewControllers = viewControllers
    }
}
