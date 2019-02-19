//
//  PointDetailContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import GoogleMaps

// MARK: - view
protocol PointDetailView: class {
}

// MARK: - presenter
protocol PointDetailViewPresentable: class {
    func initialize(map: GMSMapView, latitude: Double, longitude: Double)
}

// MARK: - interactor
protocol PointDetailUsecase: class {
}

protocol PointDetailInteractorDelegate: class {
}

// MARK: - router
protocol PointDetailWireframe: class {
}
