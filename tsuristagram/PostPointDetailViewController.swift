//
//  PostPointDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/14.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class PostPointDetailViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var latitude : Double!
    var longitude : Double!
    
    var postData = PostData()

    var marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.camera = GMSCameraPosition.camera(withLatitude: self.postData.latitude,
                                                  longitude: self.postData.longitude,
                                                  zoom: 15)
        mapView.delegate = self

        marker.position = CLLocationCoordinate2D(latitude: self.postData.latitude, longitude: self.postData.longitude)
        marker.map = mapView

    }
    
    /**
     * マップ上をロングタップすると呼ばれるメソッド
     */
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        if self.marker.map != nil {
            self.marker.map = nil
        }
        
        // 緯度経度を設定
        self.postData.latitude = coordinate.latitude
        self.postData.longitude = coordinate.longitude
        
        // マーカー設定
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.appearAnimation = GMSMarkerAnimation.pop
        self.marker.map = mapView
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /**
    * 保存ボタン
    */
    @IBAction func saveButton(_ sender: Any) {
        let postVC = storyboard!.instantiateViewController(withIdentifier: "postView") as? PostViewController
        postVC?.postData = self.postData

        let navigationController = UINavigationController(rootViewController: postVC!)
        
        self.present(navigationController, animated: true, completion: nil)

    }
}
