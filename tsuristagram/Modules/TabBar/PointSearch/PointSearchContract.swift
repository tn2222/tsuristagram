//
//  PointSearchContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/17.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol PointSearchView: class {
}

// MARK: - presenter
protocol PointSearchViewPresentable: class {
    func fetchPointData(presentLatitude: Double, presentLongitude: Double)
    func didSelectRow(point: Point)
}

// MARK: - interactor
protocol PointSearchUsecase: class {
    func fetchPointData(presentLatitude: Double, presentLongitude: Double)
}

protocol PointSearchInteractorDelegate: class {
    func interactor(_ pointSearchUsecase: PointSearchUsecase, pointList: [Point])
}

// MARK: - router
protocol PointSearchWireframe: class {
    func didSelectRow(point: Point)
}
