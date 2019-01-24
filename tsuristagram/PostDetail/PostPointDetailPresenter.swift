//
//  PostPointDetailPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/24.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

protocol PostPointDetailPresenter {
    var mapView: GMSMapView { get }
    var latitude: Double { get set }
    var longitude: Double { get set }
    func viewDidLoad()
    func didLongPressAt(coordinate: CLLocationCoordinate2D)
    func backButton()
    func saveButton()
}

class PostPointDetailPresenterImpl: PostPointDetailPresenter {

    var mapView: GMSMapView
    var latitude: Double
    var longitude: Double
    
    let router: PostPointDetailRouter
    private var marker = GMSMarker()

    init(mapView: GMSMapView, latitude: Double, longitude: Double, router: PostPointDetailRouter) {
        self.mapView = mapView
        self.latitude = latitude
        self.longitude = longitude
        self.router = router
    }
    
    func viewDidLoad() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: self.latitude,
                                                  longitude: self.longitude,
                                                  zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.map = mapView
    }
    
    func didLongPressAt(coordinate: CLLocationCoordinate2D) {
        if self.marker.map != nil {
            self.marker.map = nil
        }

        // 緯度経度を設定
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude

        // マーカー設定
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.appearAnimation = GMSMarkerAnimation.pop
        self.marker.map = mapView

    }
    
    func backButton() {
        router.backButton()
    }
    
    func saveButton() {
        router.saveButton()
    }
    
    
}
