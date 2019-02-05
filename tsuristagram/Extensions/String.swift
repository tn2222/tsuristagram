//
//  String.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/05.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation

extension String {
    
    // 文字列の中の英数字を全角から半角へ変換
    func transformFullwidthHalfwidth(reverse :Bool=false) -> String {
        var transformedChars :[String] = []
        
        let chars = self.characters.map{ String($0).uppercased() }
        chars.forEach{
            let halfwidthChar = NSMutableString(string: $0) as CFMutableString
            CFStringTransform(halfwidthChar, nil, kCFStringTransformFullwidthHalfwidth, false)
            let char = halfwidthChar as String
            
            if char.isNumber(transformHalfwidth: true) {
                CFStringTransform(halfwidthChar, nil, kCFStringTransformFullwidthHalfwidth, reverse)
                transformedChars.append(halfwidthChar as String)
            }
            else if char.isEnglish(transformHalfwidth: true) {
                CFStringTransform(halfwidthChar, nil, kCFStringTransformFullwidthHalfwidth, reverse)
                transformedChars.append(halfwidthChar as String)
            } else {
                transformedChars.append($0)
            }
        }
        
        var transformedString = ""
        transformedChars.forEach{ transformedString += $0 }
        
        return transformedString
    }
    
    func isNumber(transformHalfwidth transform :Bool) -> Bool {
        let halfwidthStr = NSMutableString(string: self) as CFMutableString
        CFStringTransform(halfwidthStr, nil, kCFStringTransformFullwidthHalfwidth, false)
        let str = halfwidthStr as String
        
        return Int(str) != nil ? true : false
    }
    
    func isEnglish(transformHalfwidth transform :Bool) -> Bool {
        let halfwidthStr = NSMutableString(string: self) as CFMutableString
        if transform {
            CFStringTransform(halfwidthStr, nil, kCFStringTransformFullwidthHalfwidth, false)
        }
        let str = halfwidthStr as String
        
        let pattern = "[A-z]*"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.stringByReplacingMatches(in: str, options: [], range: NSMakeRange(0, str.characters.count), withTemplate: "")
            if result == "" { return true }
            else { return false }
        }
        catch { return false }
    }

}
