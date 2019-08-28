//
//  CommonUtils.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/05.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

class CommonUtils {
    
    /**
     * 2点間の距離算出（球面三角法）
     */
    static func distance(current: (la: Double, lo: Double), target: (la: Double, lo: Double)) -> Double {
        
        // 緯度経度をラジアンに変換
        let currentLa   = current.la * Double.pi / 180
        let currentLo   = current.lo * Double.pi / 180
        let targetLa    = target.la * Double.pi / 180
        let targetLo    = target.lo * Double.pi / 180
        
        // 赤道半径
        let equatorRadius = 6378137.0;
        
        // 算出
        let averageLat = (currentLa - targetLa) / 2
        let averageLon = (currentLo - targetLo) / 2
        var distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)))
        distance = distance / 1000
        if distance < 0.1 {
            distance = 0.1
        }

        return round(distance*10)/10
    }

    static func getUserId() -> String {
        return UserDefaults.standard.object(forKey: "userId") as! String
    }
    
    static func getPresentLatitude() -> Double {
        return UserDefaults.standard.double(forKey: "presentLatitude")
    }
    static func getPresentLongitude() -> Double {
        return UserDefaults.standard.double(forKey: "presentLongitude")
    }
}

