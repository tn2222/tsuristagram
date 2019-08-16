//
//  PostPointLocationPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/24.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

class PostPointLocationViewPresenter: PostPointLocationViewPresentable {
    
    let view: PostPointLocationViewController
    let router: PostPointLocationWireframe
    
    private var mapView: GMSMapView!
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()
    
    init(view: PostPointLocationViewController, router: PostPointLocationWireframe) {
        self.view = view
        self.router = router
    }

    // マップ初期設定
    func initialize(map: GMSMapView, latitude: Double, longitude: Double) {
        self.mapView = map
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                  longitude: longitude,
                                                  zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.marker.map = mapView
        self.position = marker.position

    }
    
    func saveButton() {
        self.marker.position = position
        router.saveButton(latitude: position.latitude, longitude: position.longitude)
    }
    
    func backButton() {
        router.backButton()
    }
    
    func didLongPressAt(coordinate: CLLocationCoordinate2D) {
        if self.marker.map != nil {
            self.marker.map = nil
        }
        
        // マーカー設定
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.appearAnimation = GMSMarkerAnimation.pop
        self.marker.map = mapView
        
        // タップされた座標を保持
        self.position = coordinate
    }

}
