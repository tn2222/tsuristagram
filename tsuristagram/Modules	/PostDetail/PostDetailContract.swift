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
    func fetchData(postKey: String)
}

// MARK: - interactor
protocol PostDetailUsecase: class {
    func fetchData(postKey: String)
}

protocol PostDetailInteractorDelegate: class {
    func interactor(_ postDetailUsecase: PostDetailUsecase, post: Post)

}

// MARK: - router
protocol PostDetailWireframe: class {
}

