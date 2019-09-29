//
//  Referenceable.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/31.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import Foundation
import Firebase

public protocol FirebaseClientProtocol {
    static var rootRef: DatabaseReference { get }
    static var postRef: DatabaseReference { get }
    static var imageRef: StorageReference { get }
}

public extension FirebaseClientProtocol {
    static var rootRef: DatabaseReference { return Database.database().reference() }
    static var postRef: DatabaseReference { return Database.database().reference(fromURL: CommonUtils.getDatabaseURL()) }
    static var imageRef: StorageReference { return Storage.storage().reference(forURL: CommonUtils.getStorageBucket()).child("images") }
    
}

class FirebaseClient: FirebaseClientProtocol {

    static func observeSingleEvent(id: String, of eventType: DataEventType,  with block: @escaping ([String:NSDictionary]) -> Void) {

        let ref = self.rootRef.child(id)
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

    static func observeSingleEvent(id: String, limit: UInt, of eventType: DataEventType,  with block: @escaping ([String:NSDictionary]) -> Void) {
        
        let ref = self.rootRef.child(id).queryLimited(toLast: limit)
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
    
    static func observeSingleEvent(id: String, key: String, of eventType: DataEventType,  with block: @escaping ([String:AnyObject]) -> Void) {
        
        let ref = self.rootRef.child(id).child(key)
        ref.observeSingleEvent(of: .value) { (snap,error) in
            var dic: [String: AnyObject] = [:]
            snap.children.forEach({ (snapshot) in
                if let snapshot: DataSnapshot = snapshot as? DataSnapshot {
                    dic.updateValue(snapshot.value as AnyObject, forKey: snapshot.key)
                }
            })
            block(dic)
        }
    }

    static func observe(id: String, limit: UInt, offset: Int, of eventType: DataEventType,  with block: @escaping ([String: AnyObject]) -> Void) {
        
        let ref = self.rootRef.child(id)
            .queryOrdered(byChild: "timestamp")
            .queryStarting(atValue: offset)
            .queryLimited(toFirst: limit)

        ref.observe(.childAdded, with: { (snap) in
            ref.removeAllObservers()
            var dic: [String: AnyObject] = [:]
            snap.children.forEach({ (snapshot) in
                if let snapshot: DataSnapshot = snapshot as? DataSnapshot {
                    dic.updateValue(snapshot.value as AnyObject, forKey: snapshot.key)
                }
            })
            block(dic)
        })
    }

    static func observe(id: String, ordered: String, value: String, of eventType: DataEventType,  with block: @escaping ([String: AnyObject]) -> Void) {
        
        let ref = self.rootRef.child(id)
            .queryOrdered(byChild: ordered)
            .queryEqual(toValue: value)
        
        ref.observe(eventType, with: { (snap) in
            ref.removeAllObservers()
            var dic: [String: AnyObject] = [:]
            snap.children.forEach({ (snapshot) in
                if let snapshot: DataSnapshot = snapshot as? DataSnapshot {
                    dic.updateValue(snapshot.value as AnyObject, forKey: snapshot.key)
                }
            })
            block(dic)
        })
    }

    static func observeToLast(id: String, of eventType: DataEventType,  with block: @escaping ([String: AnyObject]) -> Void) {
        
        let ref = self.rootRef.child(id)
            .queryOrdered(byChild: "timestamp")
            .queryLimited(toLast: 1)
        
        ref.observe(.childAdded, with: { (snap) in
            ref.removeAllObservers()
            var dic: [String: AnyObject] = [:]
            snap.children.forEach({ (snapshot) in
                if let snapshot: DataSnapshot = snapshot as? DataSnapshot {
                    dic.updateValue(snapshot.value as AnyObject, forKey: snapshot.key)
                }
            })
            block(dic)
        })
    }

    static func setValue(id: String, feed: [String:Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).childByAutoId()
        let key = ref.key
        var post = feed
        post.updateValue(key!, forKey: "key")

        ref.setValue(post, withCompletionBlock: block)
        
    }

    static func updateChildValues(id: String, key: String, feed: [String:Any], with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).child(key)
        let post = feed
        ref.updateChildValues(post, withCompletionBlock: block)
    }

    static func userBlock(id: String, value: String, feed: [String:Any], with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).child(value).child("userBlock")
        let post = feed
        ref.updateChildValues(post, withCompletionBlock: block)
    }

    static func userUnBlock(id: String, userId: String, unblockUserId: String, with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).child(userId).child("userBlock").child(unblockUserId)
        ref.removeValue(completionBlock: block)
    }

    static func removeValue(id: String, key: String, value: String, with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).child(value)
        ref.removeValue(completionBlock: block)
    }
    
    static func disLike(postKey: String, userId: String, with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child("post").child(postKey).child("likes").child(userId)
        ref.removeValue(completionBlock: block)
    }

    static func like(postKey: String, feed: [String:Any], with block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child("post").child(postKey).child("likes")
        let likes = feed
        ref.updateChildValues(likes, withCompletionBlock: block)
    }

}

