//
//  PostPointSearchInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostPointSearchInteractor: PostPointSearchUsecase {
    // 取得処理の通知
    weak var delegate: PostPointSearchInteractorDelegate?
    
    func fetchPointData() {
        FirebaseClient.observeSingleEvent(id: "point", of: .value, with: complate)
    }
    
    func complate(snapshot: [String:NSDictionary]) {
        var pointList = [Point]()
        for (id,snap) in snapshot {
            var point: Point = Point()
            if let latitude = snap["latitude"] as? Double,
                let longitude = snap["longitude"] as? Double,
                let name = snap["name"] as? String,
                let address = snap["address"] as? String {
                point.id = id
                point.latitude = latitude
                point.longitude = longitude
                point.name = name
                point.address = address
            }
            pointList.append(point)
        }
        self.delegate?.interactor(self, pointList: pointList)
    }
    
}
