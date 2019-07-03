//
//  PointDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/02/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

class PointDetailViewController: UIViewController {

    //var mapView: GMSMapView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var marker = GMSMarker()
    private var position = CLLocationCoordinate2D()
    
    var presenter: PointDetailViewPresenter!
    var point: Point!

    var bannerView: GADBannerView!

    var postList = [Post]() {
        didSet {
            loadPostData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        //presenter.initialize(map: mapView, latitude: point.latitude, longitude: point.longitude)
        fetchData()
        
        // レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 300)
        layout.itemSize = CGSize(width: 123, height: 100)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
        
        // admob sample
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func fetchData() {
        presenter.fetchData(pointId: point.id)
    }
    
    // 画面表示でフェッチした投稿データを設定
    func setPostList(postList: [Post]) {
        if postList.count <= 0 { return }
        self.postList = postList
    }
    
    func loadPostData() {
        
        UIView.setAnimationsEnabled(false)
        
        let newDataCount = self.postList.count
        let currentDataCount = self.collectionView.numberOfItems(inSection: 0)
        
        print("newDataCount: " + String(newDataCount))
        print("currentDataCount: " + String(currentDataCount))

        self.collectionView.insertItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })
        
        self.collectionView.reloadItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })

        if postList[newDataCount - 1].latitude > 0 && postList[newDataCount - 1].longitude > 0 {
            presenter.setMarker(latitude: postList[newDataCount - 1].latitude, longitude: postList[newDataCount - 1].longitude)
        }
        UIView.setAnimationsEnabled(true)

    }
    
}

extension PointDetailViewController: GMSMapViewDelegate {

}

extension PointDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let pictureImage = cell.viewWithTag(1) as! UIImageView
        pictureImage.sd_setImage(with: URL(string: self.postList[indexPath.row].picture), completed:nil)

        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let post = postList[indexPath.row]
        
        presenter.selectCell(post: post)

        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PointDetailPageHeader", for: indexPath) as? PointDetailPageHeader else {
            fatalError("Could not find proper header")

        }

        if kind == UICollectionView.elementKindSectionHeader {

            
            header.mapView.camera = GMSCameraPosition.camera(withLatitude: point.latitude,longitude: point.longitude,zoom: 14)
            header.marker.position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            header.marker.map = header.mapView
            header.position = marker.position

            return header
        
        }
//
        return UICollectionReusableView()
    }
    
}
