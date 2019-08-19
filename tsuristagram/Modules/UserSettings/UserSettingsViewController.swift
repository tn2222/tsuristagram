//
//  UserSettingsViewController.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/08/18.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

class UserSettingsViewController: UIViewController {

    var presenter: UserSettingsViewPresenter!
    var userId: String!
    var user: User!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userImage: UIImageView!
    var userPhotoString: String!
    var isSelectPhoto: Bool = false
    override func viewDidLoad() {        
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.doneButton))

        self.presenter.fetchUserData(userId: userId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func selectEditPictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            present(pickerView, animated: true)
        }
    }
    
    @objc func doneButton() {
        SVProgressHUD.show()
        self.view?.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let uiview = UIView()
        uiview.backgroundColor = UIColor.lightGray
        uiview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        uiview.alpha = 0.3
        self.tabBarController?.view.addSubview(uiview)

        user.userName = userName.text!
        user.userPhotoImage = userImage.image!
        presenter.doneButton(user: user, isSelectPhoto: isSelectPhoto)
        isSelectPhoto = false
    }

    func setUser(user: User) {
        self.user = user
        userName.text = user.userName
        
        userPhotoString = user.userPhoto
        if userPhotoString != nil {
            userImage.sd_setImage(with: URL(string: userPhotoString), completed:nil)
            userImage.layer.cornerRadius = userImage.frame.size.width * 0.5
            userImage.clipsToBounds = true
        }
    }
}

extension UserSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userImage.image = image
        isSelectPhoto = true
        
        dismiss(animated: true,completion: nil)
    }
}
