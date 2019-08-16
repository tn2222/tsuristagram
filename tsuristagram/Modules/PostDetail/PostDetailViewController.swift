//
//  PostDetailViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/03/11.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var size: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var fishSpecies: UILabel!
    @IBOutlet var pointName: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var fishingDate: UILabel!
    
    
    var presenter: PostDetailViewPresenter!
    var postKey: String!
    var post = Post()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.fetchData(postKey: postKey)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func pointLocationButton(_ sender: Any) {
        presenter.pointLocationButton(latitude: post.latitude, longitude: post.longitude)
    }
    
    func setPostData(post: Post) {
        self.post = post
        picture.sd_setImage(with: URL(string: post.picture), completed:nil)

        size.text = post.size
        weight.text = post.weight
        fishSpecies.text = post.fishSpecies
        pointName.text = post.pointName
        weather.text = post.weather
        fishingDate.text = post.fishingDate

        //表示可能最大行数を指定
        comment.numberOfLines = 20
        //contentsのサイズに合わせてobujectのサイズを変える
        comment.text = post.comment
        comment.sizeToFit()
        //単語の途中で改行されないようにする
//        comment.lineBreakMode = NSLineBreakByWordWrapping

    }

}
