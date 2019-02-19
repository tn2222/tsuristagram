//
//  PointDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps

class PointDetailViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var collectionView: UICollectionView!
    
    var presenter: PointDetailViewPresenter!
    var point: Point!

    var postList: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.initialize(map: mapView, latitude: point.latitude, longitude: point.longitude)
    }
}

extension PointDetailViewController: GMSMapViewDelegate {

}

extension PointDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .red
        
        return cell

    }
    
    
}
