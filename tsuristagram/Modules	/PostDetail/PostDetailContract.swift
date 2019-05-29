//
//  PostDetailContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol PostDetailView: class {
}

// MARK: - presenter
protocol PostDetailViewPresentable: class {
    func pointLocationButton(latitude: Double, longitude: Double)
    func fetchData(postKey: String)
}

// MARK: - interactor
protocol PostDetailUsecase: class {
    func fetchData(postKey: String)
    func fetchPoint(pointId: String)

}

protocol PostDetailInteractorDelegate: class {
    func interactor(_ postDetailUsecase: PostDetailUsecase, post: Post)
    func interactor(_ postDetailUsecase: PostDetailUsecase, point: Point)
}

// MARK: - router
protocol PostDetailWireframe: class {
    func pointLocationButton(latitude: Double, longitude: Double)
}

