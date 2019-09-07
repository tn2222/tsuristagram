//
//  TimeLine.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/10.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

struct TimeLine {
    var user: User = User()
    var postList: [Post] = []
    var userMap: [String: User] = [:]
    var pointMap: [String: Point] = [:]
}
