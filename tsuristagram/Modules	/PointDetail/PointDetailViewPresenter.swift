//
//  PointDetailViewPresenter.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

class PointDetailViewPresenter: PointDetailViewPresentable {
    
    let view: PointDetailViewController
    let router: PointDetailWireframe
    let interactor: PointDetailUsecase
    
    private var mapView: GMSMapView!
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()

    var postList = [Post]() {
        didSet {
            view.setPostList(postList: postList)
        }
    }
    
    init(view: PointDetailViewController, router: PointDetailWireframe, interactor: PointDetailUsecase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    // マップ初期設定
    func initialize(map: GMSMapView, latitude: Double, longitude: Double) {
        self.mapView = map
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                       longitude: longitude,
                                                       zoom: 14)
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.marker.map = mapView
        self.position = marker.position
        
    }

    func fetchData(pointId: String) {
        interactor.fetchData(pointId: pointId)
    }

    func setMarker(latitude: Double, longitude: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.marker.map = mapView
        self.position = marker.position
    }

    func selectCell(post: Post) {
        router.selectCell(post: post)
    }

}

// Interactorからの通知受け取り
extension PointDetailViewPresenter: PointDetailInteractorDelegate {
    func interactor(_ pointDetailUsecase: PointDetailUsecase, post: Post) {
        postList.append(post)
    }

}
