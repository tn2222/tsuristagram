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
        
        let timeLine = TimeLineRouter.assembleModules()
        let pointSearch = PointSearchRouter.assembleModules()

        timeLine.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.mostRecent, tag: 0)
        pointSearch.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 0)

        viewControllers.append(timeLine)
        viewControllers.append(pointSearch)

        self.viewControllers = viewControllers
    }
}
