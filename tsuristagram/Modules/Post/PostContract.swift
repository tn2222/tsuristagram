//
//  PostViewContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/04.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

// MARK: - view
protocol PostView: class {
}

// MARK: - presenter
protocol PostViewPresentable: class {
    func fetchPointData(latitude: Double, longitude: Double)
    func updateButton(post: Post)
    func postButton(post: Post)
    func updateCancelButton()
    func cancelButton()
    func pointLocationButton(latitude: Double, longitude: Double)
    func pointSearchButton(pointList: [Point])
}

// MARK: - interactor
protocol PostUsecase: class {
    func fetchPointData(latitude: Double, longitude: Double)
    func updateButton(post: Post)
    func postButton(post: Post)
}

protocol PostInteractorDelegate: class {
    func interactor(_ postUsecase: PostUsecase, pointList: [Point])
    func interactor(_ postUsecase: PostUsecase, error: Error?)
}

// MARK: - router
protocol PostWireframe: class {
    func postComplate()
    func updateCancelButton()
    func cancelButton()
    func pointLocationButton(latitude: Double, longitude: Double)
    func pointSearchButton(pointList: [Point])
}

