//
//  PostInteractor.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/04.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostInteractor: PostUsecase {
    // 取得処理の通知
    weak var delegate: PostInteractorDelegate?
    
    var latitude: Double!
    var longitude: Double!
    
    func fetchPointData(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
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
                
                point.distance = CommonUtils.distance(current: (la: self.latitude, lo: self.longitude), target: (la: latitude, lo: longitude))
            }
            pointList.append(point)
        }
        self.delegate?.interactor(self, pointList: pointList)
    }


}
