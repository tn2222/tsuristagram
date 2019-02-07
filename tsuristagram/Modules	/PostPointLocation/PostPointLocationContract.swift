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
    func saveButton(post: Post)
    func didLongPressAt(coordinate: CLLocationCoordinate2D)
    func initialize(map: GMSMapView, post: Post)
    func backButton()
}

// MARK: - interactor
protocol PostPointLocationUsecase: class {
}

// MARK: - router
protocol PostPointLocationWireframe: class {
    func saveButton(post: Post)
    func backButton()
}

