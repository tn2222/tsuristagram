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
    func viewWillAppear()
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
    private var positionOriginal = CLLocationCoordinate2D()
    private var position = CLLocationCoordinate2D()
    
    init(mapView: GMSMapView, latitude: Double, longitude: Double, router: PostPointDetailRouter) {
        self.mapView = mapView
        self.latitude = latitude
        self.longitude = longitude
        self.router = router
    }
    
    func viewWillAppear() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: self.latitude,
                                                  longitude: self.longitude,
                                                  zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.map = mapView
        positionOriginal = marker.position
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
        position = coordinate
    }
    
    func backButton() {
        setPosition(position: positionOriginal)
        router.backButton()
    }
    
    func saveButton() {
        setPosition(position: position)
        router.saveButton()
    }
    
    private func setPosition(position: CLLocationCoordinate2D) {
        self.marker.position = position
        self.latitude = position.latitude
        self.longitude = position.longitude
    }
}
