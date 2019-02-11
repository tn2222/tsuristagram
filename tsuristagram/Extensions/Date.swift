//
//  DateUtils.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/14.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

extension Date {

    static func currentTimeString() -> String {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        return formatter.string(from: now as Date)
    }

    static func currentTimeString(format: String) -> String {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
    }

    // yyyyMMddHHmmssSSS to yyyy/MM/dd HH:mm
    static func DateFormat(dateString: String) -> String {
        let date = Date.stringToDate(string: dateString, format: "yyyyMMddHHmmssSSS")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date as Date)
    }

    static func stringToDate(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.date(from: string)! as Date
    }

    static func dateToString(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

}
