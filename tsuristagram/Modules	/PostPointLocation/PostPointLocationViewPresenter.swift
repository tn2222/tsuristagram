//
//  PostPointLocationPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/24.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

//protocol PostPointLocationPresenter {
//    var mapView: GMSMapView { get }
//    var post: Post { get set }
//    func viewWillAppear()
//    func didLongPressAt(coordinate: CLLocationCoordinate2D)
//    func backButton()
//    func saveButton(post: Post)
//}

class PostPointLocationViewPresenter: PostPointLocationViewPresentable {

    var mapView: GMSMapView!
    var post: Post!
    
    let view: PostPointLocationViewController
    let router: PostPointLocationWireframe
    
    private var marker = GMSMarker()
    private var positionOriginal = CLLocationCoordinate2D()
    private var position = CLLocationCoordinate2D()
    
    init(view: PostPointLocationViewController, router: PostPointLocationWireframe) {
        self.view = view
        self.router = router
    }

    func initialize(map: GMSMapView, post: Post) {
        self.mapView = map
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: post.latitude,
                                                  longitude: post.longitude,
                                                  zoom: 15)
        marker.position = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
        self.marker.map = mapView

        self.position = marker.position
        self.positionOriginal = self.position
        
        self.post = post
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
    
    func saveButton(post: Post) {
        self.marker.position = position
        self.post.latitude = position.latitude
        self.post.longitude = position.longitude
        
        router.saveButton(post: self.post)
    }
    
    func backButton() {
        router.backButton()
    }
    
}
