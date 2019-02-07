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
    static var rootRef: DatabaseReference { get }
    static var postRef: DatabaseReference { get }
    
    static func observeSingleEvent(id: String, of eventType: DataEventType, with block: @escaping ([String:NSDictionary]) -> Void)
}

public extension FirebaseClientProtocol {
    static var rootRef: DatabaseReference { return Database.database().reference() }
    static var postRef: DatabaseReference { return Database.database().reference(fromURL: "https://tsuristagram.firebaseio.com/") }
    
}

class FirebaseClient: FirebaseClientProtocol {

    static func observeSingleEvent(id: String, of eventType: DataEventType,  with block: @escaping ([String:NSDictionary]) -> Void) {

        let ref: DatabaseReference = self.rootRef.child(id)

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

    static func setValue(id: String, feed: [String:Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).childByAutoId()
        ref.setValue(feed, withCompletionBlock: block)
    }
}
