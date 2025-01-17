//
//  ProfileViewController.swift
//  Travo-App
//
//  Created by Sogyal Thundup Sherpa on 16/9/19.
//  Copyright © 2019 Sogyal Thundup Sherpa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
  
    @IBOutlet var profileBackground: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var cityCollection: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var currentCityLabel: UILabel!
    @IBOutlet var interestLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    var currentUser:UserCoreData!
    
    let currentCity:String = "Melbourne"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        aboutMeLabel.text = currentUser.getDescription()
        interestLabel.text = currentUser.getInterests()
        currentCityLabel.text = currentCity
        let image = currentUser?.userImage
        profileImage.image = UIImage(data: image! as Data)
        profileImage.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        profileBackground.layer.cornerRadius = 20
        cityCollection.delegate = self
        cityCollection.dataSource = self
        userNameLabel.text = currentUser.getUser()
        interestLabel.text = currentUser.getInterests()
        aboutMeLabel.text = currentUser.getDescription()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser.getCities().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityVisitedCollectionViewCell
        cell.cityLabel.text = currentUser.getCity(index:indexPath.row)
        return cell
    }

}
