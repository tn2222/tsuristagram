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
        
        // 他のViewと被らない値を代入
        loadingIndicator.tag = 999
        whiteOutView.tag = 999
        
        self.view.addSubview(whiteOutView)
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(whiteOutView)
        self.view.bringSubviewToFront(loadingIndicator)
        
        loadingIndicator.startAnimating()
    }
    
    func startIndicator(view: UIView) {
        
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        
        loadingIndicator.center = view.center
        let whiteOutView = UIView(frame: view.frame)

        whiteOutView.backgroundColor = .gray
        
        // 他のViewと被らない値を代入
        loadingIndicator.tag = 999
        whiteOutView.tag = 999
        
        view.addSubview(whiteOutView)
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(whiteOutView)
        view.bringSubviewToFront(loadingIndicator)
        
        loadingIndicator.startAnimating()
    }

    func dismissIndicator(view: UIView) {
        view.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
            }
        }
    }

    func dismissIndicator() {
        self.view.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}

// notification
extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}
