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

    var latitude: Double!
    var longitude: Double!
    var editFlag: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backButton))
        
        if editFlag {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.saveButton))
        }

        mapView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialize(map: mapView, latitude: latitude, longitude: longitude)
    }
    
    //保存ボタン
    @objc func saveButton() {
        presenter.saveButton()
    }
    
    @objc func backButton() {
        presenter.backButton()

    }
}

extension PostPointLocationViewController: GMSMapViewDelegate {
    // マップ上をロングタップすると呼ばれるメソッド
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if editFlag {
            presenter.didLongPressAt(coordinate: coordinate)
        }
    }
}
