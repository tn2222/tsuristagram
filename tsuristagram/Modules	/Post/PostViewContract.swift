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
    func postButton(post: Post)
    func cancelButton()
    func pointLocationButton(post: Post)
    func pointSearchButton(post: Post)
}

// MARK: - interactor
protocol PostUsecase: class {
    func fetchPointData(latitude: Double, longitude: Double)
}

protocol PostInteractorDelegate: class {
    func interactor(_ postUsecase: PostUsecase, pointList: [Point])
}

// MARK: - router
protocol PostWireframe: class {
    func postButton()
    func cancelButton()
    func pointLocationButton(post: Post)
    func pointSearchButton(post: Post)
}

