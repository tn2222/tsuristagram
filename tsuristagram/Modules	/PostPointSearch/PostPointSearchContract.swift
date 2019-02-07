//
//  PostPointSearchContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/04.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol PostPointSearchView: class {
}

// MARK: - presenter
protocol PostPointSearchViewPresentable: class {
    func didSelectRow(point: Point)
}

// MARK: - interactor
protocol PostPointSearchUsecase: class {
}

// MARK: - router
protocol PostPointSearchWireframe: class {
    func didSelectRow(point: Point)
}

