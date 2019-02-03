//
//  Referenceable.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/31.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import FirebaseDatabase


public protocol FirebaseClientProtocol {

    static var database: DatabaseReference { get }
    static func observeSingleEvent(id: String, of eventType: DataEventType, with block: @escaping ([String:NSDictionary]) -> Void)
}

public extension FirebaseClientProtocol {
    static var database: DatabaseReference { return Database.database().reference() }

}

class FirebaseClient: FirebaseClientProtocol {

    static func observeSingleEvent(id: String, of eventType: DataEventType,  with block: @escaping ([String:NSDictionary]) -> Void) {

        let ref: DatabaseReference = self.database.child(id)

        ref.observeSingleEvent(of: .value) { (snap,error) in
            var snapshot: [String:NSDictionary]?
            snapshot = snap.value as? [String:NSDictionary]
            if snapshot != nil {
                block(snapshot!)
            } else {
                block([:])
            }
        }
    }

}
