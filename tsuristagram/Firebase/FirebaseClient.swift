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

//    static func observeSingleEvent(id: String, of eventType: DataEventType, with block: @escaping ([String:NSDictionary]) -> Void)
}

public extension FirebaseClientProtocol {
    static var rootRef: DatabaseReference { return Database.database().reference() }
    static var postRef: DatabaseReference { return Database.database().reference(fromURL: "https://tsuristagram.firebaseio.com/") }
    static var imageRef: StorageReference { return Storage.storage().reference(forURL: "gs://tsuristagram.appspot.com").child("images") }
    
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

    static func setValue(id: String, feed: [String:Any], withCompletionBlock block: @escaping (Error?, DatabaseReference) -> Void) {
        let ref: DatabaseReference = self.postRef.child(id).childByAutoId()
        ref.setValue(feed, withCompletionBlock: block)
    }
    
//    static func putData(id: String, uploadPhotoImage: UIImage, withCompletionBlock metadata: @escaping (Error?, StorageMetadata) -> Void) {
//        let currentTime = Date.currentTimeString()
//        let ref: StorageReference = self.imageRef.child(id).child(currentTime + ".jpg")
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        let photoImageUploadData = uploadPhotoImage.jpegData(compressionQuality: 0.1)
//
//        let uploadTask = ref.putData(photoImageUploadData, metadata: metadata, complate: complate)
//
//    }
}

