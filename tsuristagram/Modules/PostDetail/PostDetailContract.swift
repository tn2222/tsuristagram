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
    func userButton(userId: String)
    func pointButton(point: Point)
    func fetchData(postKey: String)
    func deleteButton(post: Post)
    func presentEditView(post: Post)
}

// MARK: - interactor
protocol PostDetailUsecase: class {
    func fetchUserData(userId: String)
    func fetchData(postKey: String)
    func fetchPoint(pointId: String)
    func deleteButton(post: Post)
}

protocol PostDetailInteractorDelegate: class {
    func interactor(_ postDetailUsecase: PostDetailUsecase, user: User)
    func interactor(_ postDetailUsecase: PostDetailUsecase, post: Post)
    func interactor(_ postDetailUsecase: PostDetailUsecase, point: Point)
    func interactor(_ postDetailUsecase: PostDetailUsecase, error: Error?)

}

// MARK: - router
protocol PostDetailWireframe: class {
    func pointLocationButton(latitude: Double, longitude: Double)
    func userButton(userId: String)
    func pointButton(point: Point)
    func presentEditView(post: Post)
    func deleteComplate()
}

