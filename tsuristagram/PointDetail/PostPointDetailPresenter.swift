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
    var post: Post { get set }
    func viewWillAppear()
    func didLongPressAt(coordinate: CLLocationCoordinate2D)
    func backButton()
    func saveButton(post: Post)
}

class PostPointDetailPresenterImpl: PostPointDetailPresenter {
    
    var mapView: GMSMapView
    var post: Post
    
    let router: PostPointDetailRouter
    private var marker = GMSMarker()
    private var positionOriginal = CLLocationCoordinate2D()
    private var position = CLLocationCoordinate2D()
    
    init(mapView: GMSMapView, post: Post, router: PostPointDetailRouter) {
        self.mapView = mapView
        self.post = post
        self.router = router
    }
    
    func viewWillAppear() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: self.post.latitude,
                                                  longitude: self.post.longitude,
                                                  zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: self.post.latitude, longitude: self.post.longitude)
        marker.map = mapView

        position = marker.position
        positionOriginal = position
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
        // マーカーを元の位置に戻しておく。
        setPosition(position: positionOriginal)
        router.backButton()
    }
    
    func saveButton(post: Post) {
        setPosition(position: position)
        self.post.latitude = position.latitude
        self.post.longitude = position.longitude
        
        router.saveButton(post: self.post)
    }
    
    private func setPosition(position: CLLocationCoordinate2D) {
        self.marker.position = position
    }
}
