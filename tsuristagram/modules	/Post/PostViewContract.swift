//
//  PostViewContract.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/04.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class PostViewContract: NSObject {

}

// MARK: - view
protocol PostPointView: class {
}

// MARK: - presenter
protocol PostPointViewPresentable: class {
    func getPoint(latitude: Double, longitude: Double)
    func postButton(post: Post)
    func cancelButton()
    func pointDetailButton(post: Post)
    func pointSearchButton(post: Post)
}

// MARK: - interactor
protocol PostPointUsecase: class {
}

protocol PostPointInteractorDelegate: class {
}

// MARK: - router
protocol PostPointWireframe: class {
    func postButton()
    func cancelButton()
    func pointDetailButton(post: Post)
    func pointSearchButton(post: Post)
    func setPoint(pointName: String, pointId: String)
}

