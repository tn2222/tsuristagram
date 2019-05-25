//
//  UIViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/05/25.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func startIndicator() {
        
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        
        loadingIndicator.center = self.view.center
        let whiteOutView = UIView(frame: self.view.frame)
        whiteOutView.backgroundColor = .white
//        whiteOutView.alpha = 0.6
        
        // 他のViewと被らない値を代入
        loadingIndicator.tag = 999
        whiteOutView.tag = 999
        
//        let label = UILabel()
//        label.frame = CGRect(x : 0, y : 0, width : 150, height : 150)
//        label.layer.position = CGPoint(x:loadingIndicator.frame.width / 2.0 , y:loadingIndicator.frame.height / 2.0 + 50.0)
//        label.text = "Loading..."
//        label.textAlignment = NSTextAlignment.center
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = UIColor.white
//        loadingIndicator.addSubview(label)

        self.view.addSubview(whiteOutView)
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(whiteOutView)
        self.view.bringSubviewToFront(loadingIndicator)
        
        loadingIndicator.startAnimating()
    }
    
    func dismissIndicator() {
        self.view.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
            }
        }
    }
    
}
