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
    func fetchData(pointId: String)
    func setMarker(latitude: Double, longitude: Double)
    func selectCell(post: Post)
}

// MARK: - interactor
protocol PointDetailUsecase: class {
    func fetchData(pointId: String)
}

protocol PointDetailInteractorDelegate: class {
    func interactor(_ pointDetailUsecase: PointDetailUsecase, post: Post)
}

// MARK: - router
protocol PointDetailWireframe: class {
    func selectCell(post: Post)
}
