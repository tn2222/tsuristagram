//
//  PointSearchInteractor.swift
//
//
//  Created by takuya nakazawa on 2019/02/17.
//

import Foundation

class PointSearchInteractor: PointSearchUsecase {
    
    // 取得処理の通知
    weak var delegate: PointSearchInteractorDelegate?
    var presentLatitude: Double!
    var presentLongitude: Double!
    
    func fetchPointData(presentLatitude: Double, presentLongitude: Double) {
        self.presentLatitude = presentLatitude
        self.presentLongitude = presentLongitude
        FirebaseClient.observeSingleEvent(id: "point", of: .value, with: fetchComplate)
    }
    
    func fetchComplate(snapshot: [String:NSDictionary]) {
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
                point.distance = CommonUtils.distance(current: (la: self.presentLatitude, lo: self.presentLongitude), target: (la: latitude, lo: longitude))

            }
            pointList.append(point)
        }
        self.delegate?.interactor(self, pointList: pointList)
    }
    
}
