//
//  Post.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2018/12/12.
//  Copyright © 2018 takuya nakazawa. All rights reserved.
//

import UIKit

class PostData: NSObject {
    var userName: String = String()
    var userPhoto: String = String()
    var userId: String = String()

    var size: String = String()
    var weight: String = String()
    var fishSpecies: String = String()
    var comment: String = String()
    var fishingDate: String = String()
    var picture: String = String()
    var pointId: Int = Int()
    var latitude: Double = Double()
    var longitude: Double = Double()
    var weather: String = String()

    var uploadPhotoImage: UIImage = UIImage()
    var assetUrl: URL!
    
    
    
}
