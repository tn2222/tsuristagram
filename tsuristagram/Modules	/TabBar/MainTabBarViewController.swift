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
        
        var viewControllers: [UIViewController] = []
        
        let timeLine = TimeLineRouter.assembleModules()
        let pointSearch = PointSearchRouter.assembleModules()
        let userPage = UserPageRouter.assembleModules()

        
        // tabBar設定
        timeLine.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.mostRecent, tag: 0)
        pointSearch.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 0)
        userPage.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 0)

        // navigationBar設定
        let timeLineNav = UINavigationController(rootViewController: timeLine)
        let pointSearchNav = UINavigationController(rootViewController: pointSearch)
        let userPageNav = UINavigationController(rootViewController: userPage)

        timeLineNav.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 17)!]
        pointSearchNav.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 17)!]
        userPageNav.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 17)!]

        viewControllers.append(timeLineNav)
        viewControllers.append(pointSearchNav)
        viewControllers.append(userPageNav)
        
        self.viewControllers = viewControllers
    }
}
