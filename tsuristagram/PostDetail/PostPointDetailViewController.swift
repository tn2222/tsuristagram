//
//  PostPointDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/14.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps

class PostPointDetailViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var presenter: PostPointDetailPresenter!

    var postData = Post()
    var marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postVC = storyboard!.instantiateViewController(withIdentifier: "postView") as? PostViewController
        let router = PostPointDetailRouterImpl(postPointDetailViewController: self, postViewController: postVC!)
        self.presenter = PostPointDetailPresenterImpl(mapView: mapView, latitude: postData.latitude, longitude: postData.longitude, router: router)

        mapView.delegate = self
        presenter.viewDidLoad()
    }
    
    /**
     * マップ上をロングタップすると呼ばれるメソッド
     */
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        presenter.didLongPressAt(coordinate: coordinate)
    }

    @IBAction func backButton(_ sender: Any) {
        presenter.backButton()
    }

    /**
    * 保存ボタン
    */
    @IBAction func saveButton(_ sender: Any) {
        presenter.saveButton()
    }
}
