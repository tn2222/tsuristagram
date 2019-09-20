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
    
//    private var mapView: GMSMapView!
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()
    
    init(view: PostPointLocationViewController, router: PostPointLocationWireframe) {
        self.view = view
        self.router = router
    }

    // マップ初期設定
    func initialize(map: GMSMapView, latitude: Double, longitude: Double) {
        
        var camera: GMSCameraPosition
        
        // 写真の緯度経度が取れない場合
        if latitude == 0 && longitude == 0 {
            // 現在地が取得できた場合は現在地付近を表示
            if CommonUtils.getPresentLatitude() != 0 && CommonUtils.getPresentLongitude() != 0 {
                camera = GMSCameraPosition.camera(withLatitude: CommonUtils.getPresentLatitude(),
                                                  longitude: CommonUtils.getPresentLongitude(),
                                                  zoom: 15)
            } else {
                // 現在地が取得できない場合は、定点（東京）
                camera = GMSCameraPosition.camera(withLatitude: 35.7020691,
                                                  longitude: 139.7753269,
                                                  zoom: 15)
            }
        } else {
            // 写真の緯度経度が取得できた場合
            camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 15)
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        map.camera = camera
        self.marker.map = map
        self.position = marker.position

    }
    
    func saveButton() {
        self.marker.position = position
        router.saveButton(latitude: position.latitude, longitude: position.longitude)
    }
    
    func backButton() {
        router.backButton()
    }
    
    func didLongPressAt(coordinate: CLLocationCoordinate2D, map: GMSMapView) {
        if self.marker.map != nil {
            self.marker.map = nil
        }
        
        // マーカー設定
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.appearAnimation = GMSMarkerAnimation.pop
        self.marker.map = map
        
        // タップされた座標を保持
        self.position = coordinate
    }

}
