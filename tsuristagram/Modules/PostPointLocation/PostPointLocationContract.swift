//
//  PostPointLocationContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/06.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

// MARK: - view
protocol PostPointLocationView: class {
}

// MARK: - presenter
protocol PostPointLocationViewPresentable: class {
    func initialize(map: GMSMapView, latitude: Double, longitude: Double)
    func saveButton()
    func backButton()
    func didLongPressAt(coordinate: CLLocationCoordinate2D, map: GMSMapView)
}

// MARK: - interactor
protocol PostPointLocationUsecase: class {
}

// MARK: - router
protocol PostPointLocationWireframe: class {
    func saveButton(latitude: Double, longitude: Double)
    func backButton()
}

