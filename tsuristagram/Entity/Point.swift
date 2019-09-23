//
//  Point.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/03.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

struct Point {
    var id: String = String()
    var name: String = String()
    var address: String = String()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var distance: Double = Double()
    // 写真、もしくは現在地の緯度経度が取得できたかどうか判別するためのフラグ
    var positionGetFlag: Bool = Bool()
}
