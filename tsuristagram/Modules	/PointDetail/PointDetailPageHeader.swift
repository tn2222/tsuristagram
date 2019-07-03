//
//  PointDetailPageHeader.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/06/30.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps

final class PointDetailPageHeader: UICollectionReusableView{
    
    @IBOutlet weak var mapView: GMSMapView!
    var marker = GMSMarker()
    var position = CLLocationCoordinate2D()
    
}

extension PointDetailPageHeader: GMSMapViewDelegate {
    
}
