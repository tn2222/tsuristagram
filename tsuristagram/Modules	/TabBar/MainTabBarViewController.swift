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
            = [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 17)!,.foregroundColor: UIColor.white]
        pointSearchNav.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 17)!,.foregroundColor: UIColor.white]
        userPageNav.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 17)!,.foregroundColor: UIColor.white]
        
        //Below is Yosuke Ujigawa adding cood..
        timeLineNav.navigationBar.barTintColor = UIColor(red: 69/255, green: 151/255, blue: 231/255, alpha: 1)
        pointSearchNav.navigationBar.barTintColor = UIColor(red: 69/255, green: 151/255, blue: 231/255, alpha: 1)
        userPageNav.navigationBar.barTintColor = UIColor(red: 69/255, green: 151/255, blue: 231/255, alpha: 1)

        viewControllers.append(timeLineNav)
        viewControllers.append(pointSearchNav)
        viewControllers.append(userPageNav)
        
        self.viewControllers = viewControllers
    }
}
