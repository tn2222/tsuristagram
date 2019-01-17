//
//  PostPointDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/01/14.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps

class PostPointDetailViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var gmsMapView: GMSMapView!
    
    var latitude = Double()
    var longitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.latitude)
        print(self.longitude)

    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude,
                                              longitude: self.longitude,
                                              zoom: 15)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        self.view = mapView

        let position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = gmsMapView
        

    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
