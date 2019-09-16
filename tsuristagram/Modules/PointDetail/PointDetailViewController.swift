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
    
    var header: PointDetailPageHeader!
    var presenter: PointDetailViewPresenter!
    var point: Point!

    var bannerView: GADBannerView!
    
    var postList = [Post]() {
        didSet {
            if (fetchComplateWorkItem != nil){
                fetchComplateWorkItem.cancel()
            }
            loadPostData()
        }
    }

    var fetchComplateWorkItem: DispatchWorkItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

//        startIndicator()

        presenter.fetchUserData()
        
        // レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.width * 2 / 3)
        if self.view.bounds.width < 600 {
            layout.itemSize = CGSize(width:self.view.frame.size.width / 3 - 2, height:self.view.frame.size.width / 3 - 2)
        } else {
            layout.itemSize = CGSize(width:self.view.frame.size.width / 6 - 2, height:self.view.frame.size.width / 6 - 2)
        }
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
        
        // admob sample
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1824291251550532/5494248531"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.header.mapView != nil {
            self.header.mapView.clear()
            self.header.mapView.removeFromSuperview()
            self.header.mapView = nil
        }
        self.header = nil


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
    
    func fetchData() {
        presenter.fetchData(pointId: point.id)
    }
    
    // 画面表示でフェッチした投稿データを設定
    func setPostList(postList: [Post]) {
        if postList.count <= 0 { return }
        self.postList = postList
    }
    
    func loadPostData() {

        fetchComplateWorkItem = DispatchWorkItem() {
            UIView.setAnimationsEnabled(false)

            let newDataCount = self.postList.count
            let currentDataCount = self.collectionView.numberOfItems(inSection: 0)

            print("newDataCount: " + String(newDataCount))
            print("currentDataCount: " + String(currentDataCount))

            self.collectionView.insertItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })
            
            self.collectionView.reloadItems(at: Array(currentDataCount..<newDataCount).map { IndexPath(row: $0, section: 0) })

            if self.postList[newDataCount - 1].latitude > 0 && self.postList[newDataCount - 1].longitude > 0 {
                self.presenter.setMarker(latitude: self.postList[newDataCount - 1].latitude, longitude: self.postList[newDataCount - 1].longitude)
            }
//            self.dismissIndicator()

            UIView.setAnimationsEnabled(true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: self.fetchComplateWorkItem)

    }
    
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

        self.header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PointDetailPageHeader", for: indexPath) as? PointDetailPageHeader
        if kind == UICollectionView.elementKindSectionHeader {

            if point.latitude == 0 && point.longitude == 0 {
                if self.header.mapView != nil {
                    self.header.mapView.removeFromSuperview()
                }
                self.header.backgroundColor = UIColor.lightGray
                let label: UILabel = UILabel()
                label.frame = CGRect(x:150, y:200, width:160, height:30)
                label.textColor = UIColor.black
                label.textAlignment = .center
                label.center = self.header.center
                label.font = UIFont.systemFont(ofSize: 20)
                label.text = "不明な釣り場"
                self.header.addSubview(label)

            } else {
                self.header.mapView.camera = GMSCameraPosition.camera(withLatitude: point.latitude,longitude: point.longitude,zoom: 14)
                self.header.marker.position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                self.header.marker.map = self.header.mapView
                self.header.position = marker.position
            }

            return self.header
        
        }

        return UICollectionReusableView()
    }
    
}
