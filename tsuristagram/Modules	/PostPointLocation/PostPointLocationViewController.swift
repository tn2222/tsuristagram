//
//  PostPointLocationViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/14.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps

class PostPointLocationViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    
    var presenter: PostPointLocationViewPresentable!

    var post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backButton))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.saveButton))

        mapView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialize(map: mapView, post: post)
    }
    
    //保存ボタン
    @objc func saveButton() {
        presenter.saveButton(post: post)
    }
    
    @objc func backButton() {
        presenter.backButton()

    }
    
}

extension PostPointLocationViewController: GMSMapViewDelegate {
    // マップ上をロングタップすると呼ばれるメソッド
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        presenter.didLongPressAt(coordinate: coordinate)
    }
}
