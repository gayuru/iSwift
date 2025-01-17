//
//  FavouritesCollectionViewController.swift
//  Travo-App
//
//  Created by Gayuru Gunawardana on 21/8/19.
//  Copyright © 2019 Sogyal Thundup Sherpa. All rights reserved.
//

import UIKit
import Cosmos

class FavouritesViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet var bottomNav: UIView!
    @IBOutlet var favouriteButton: UIImageView!
    @IBOutlet var displayLabel: UILabel!
    
    var currentUser : UserCoreData?
    var viewModel:PlacesViewModel!
    var currTitle : String = ""
    var currentCategory : String = "general"
    var favourites : [Place]!
    var currentIndex:Int = 0
    var currentCollection:collections = collections.favourites
    
    lazy var tempRecommended = viewModel.getRecommended(category: self.currentCategory)
    lazy var tempPopular = viewModel.getPopularity(category: self.currentCategory)
    
    //to determine which collection is being passed to use the view as a general view
    enum collections{
        case favourites
        case popular
        case recommended
    }
    
    let cellScaling:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favourites = currentUser?.getFavourites()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        bottomNav.layer.cornerRadius = 10
        bottomNav.layer.masksToBounds = true
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
}

extension FavouritesViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(validateUser()){
            if (currentCollection==collections.favourites &&
                (currentUser?.getFavourites().count)! <= 0){
                displayLabel.text = "No Favourites"
                favouriteButton.image = UIImage(named: "nav_heart_enabled")
                return 0
            }else if(currentCollection==collections.favourites){
                displayLabel.isHidden = true
                return (currentUser?.getFavourites().count)!
            }else if(currentCollection==collections.recommended){
                return 5
            }
        }
        displayLabel.isHidden = true
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCell", for: indexPath) 
        let title = cell.viewWithTag((1000)) as! UILabel
        let location = cell.viewWithTag((1001)) as! UILabel
        let openTime = cell.viewWithTag((1002)) as! UILabel
        let imageView = cell.viewWithTag((1003)) as! UIImageView
        let placeRating = cell.viewWithTag((1004)) as! CosmosView
        let favourite = cell.viewWithTag((1005)) as! UIButton
        placeRating.settings.updateOnTouch = false
        placeRating.settings.fillMode = .precise
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.sizeToFit()
        favourite.id = indexPath.row
        favourite.addTarget(self, action: #selector(likePlace(sender:)), for: UIControl.Event.touchUpInside)
        if((currentUser?.getFavourites().count)!>=0){
            favourites.forEach { (place) in
                if place.name == title.text{
                    favourite.setImage(UIImage(named: "like"), for: .normal)
                }
            }
        }
        if(currentCollection == collections.favourites && (currentUser?.getFavourites().count)! <= 0){
            return cell
        }
        //adopt the view accordingly
        switch currentCollection {
        case collections.popular:
            heading.text = "Popular Places"
            tempPopular = viewModel.getPopularity(category: currentCategory)
            title.text = tempPopular[indexPath.row].name
            imageView.image = viewModel.getImageURLFor(url: tempPopular[indexPath.row].imageURL)
            location.text = tempPopular[indexPath.row].location
            openTime.text = tempPopular[indexPath.row].openTime
            placeRating.rating = tempPopular[indexPath.row].starRating
            placeRating.text = String(tempPopular[indexPath.row].starRating)
            currentIndex = indexPath.row
            if((currentUser?.getFavourites().count)!>=0){
                favourites.forEach { (place) in
                    if place.name == title.text{
                        favourite.setImage(UIImage(named: "like"), for: .normal)
                    }
                }
            }
        case collections.recommended:
            heading.text = "Recommended Places"
            tempRecommended = viewModel.getRecommended(category: self.currentCategory)
            title.text = tempRecommended[indexPath.row].name
            imageView.image = viewModel.getImageURLFor(url:tempRecommended[indexPath.row].imageURL)
            location.text = tempRecommended[indexPath.row].location
            openTime.text = tempRecommended[indexPath.row].openTime
            placeRating.rating = tempRecommended[indexPath.row].starRating
            if((currentUser?.getFavourites().count)!>=0){
                favourites.forEach { (place) in
                    if place.name == title.text{
                        favourite.setImage(UIImage(named: "like"), for: .normal)
                    }
                }
            }
            placeRating.text = String(tempRecommended[indexPath.row].starRating)
        default:
            heading.text = "Favourites"
            if((currentUser?.getFavourites().count)!>0){
                if let favourites = currentUser?.getFavourites()[indexPath.row]{
                    title.text = favourites.name
                    imageView.image = viewModel.getImageURLFor(index: indexPath.row)
                    location.text = favourites.location
                    openTime.text = favourites.openTime
                    placeRating.rating = favourites.starRating
                    placeRating.text = String(favourites.starRating)
                    favouriteButton.image = UIImage(named: "nav_heart_enabled")
                    if((currentUser?.getFavourites().count)!>=0){
                        self.favourites.forEach { (place) in
                            if place.name == title.text{
                                favourite.setImage(UIImage(named: "like"), for: .normal)
                            }
                        }
                    }
                }
            }else{
                title.text = viewModel.getTitleFor(index: indexPath.row)
                imageView.image = viewModel.getImageURLFor(index: indexPath.row)
                location.text = viewModel.getLocationFor(index: indexPath.row)
                openTime.text = viewModel.getOpenTimeFor(index: indexPath.row)
                placeRating.rating = viewModel.getStarRating(index: indexPath.row)
                placeRating.text = String(viewModel.getStarRating(index: indexPath.row))
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentCollection == collections.popular{
            currTitle = tempPopular[indexPath.row].name
            performSegue(withIdentifier: "goToPlace", sender: self)
        }else if currentCollection == collections.recommended{
            currTitle = tempRecommended[indexPath.row].name
            performSegue(withIdentifier: "goToPlace", sender: self)
        }else if currentCollection == collections.favourites{
            currTitle = favourites[indexPath.row].name
            performSegue(withIdentifier: "goToPlace", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToPlace"){
            let placeController = segue.destination as! PlaceViewController
            placeController.viewModel = self.viewModel
            placeController.currentUser = currentUser
            placeController.indexPass = currTitle
        }else if (segue.identifier == "goToPlace"){
            let placeController = segue.destination as! PlaceViewController
            placeController.viewModel = self.viewModel
            placeController.currentUser = currentUser
            placeController.indexPass = currTitle
        }
    }
    
    @objc func likePlace(sender:UIButton){
        switch currentCollection {
        case collections.recommended:
            if sender.currentImage == UIImage(named: "heart") {
                if ((currentUser?.addToFavourites(place: tempRecommended[sender.id]))!){
                    sender.setImage(UIImage(named:"like"), for: .normal)
                }
            }else{
                sender.setImage(UIImage(named:"heart"), for: .normal)
                _ = currentUser?.removeFavourites(place: tempRecommended[sender.id])
            }
        case collections.popular:
            if sender.currentImage == UIImage(named: "heart") {
                if ((currentUser?.addToFavourites(place: tempPopular[sender.id]))!){
                    sender.setImage(UIImage(named:"like"), for: .normal)
                }
            }else{
                sender.setImage(UIImage(named:"heart"), for: .normal)
                _ = currentUser?.removeFavourites(place: tempPopular[sender.id])
            }
        default:
            if sender.currentImage == UIImage(named: "heart") {
                if ((currentUser?.addToFavourites(place: favourites[sender.id]))!){
                    sender.setImage(UIImage(named:"like"), for: .normal)
                }
            }else{
                sender.setImage(UIImage(named:"heart"), for: .normal)
                _ = currentUser?.removeFavourites(place: favourites[sender.id])
            }
        }
        
    }
    
    func validateUser() -> Bool{
        if currentUser != nil{
            return true
        }
        return false
    }
}

extension UIButton{
    var id:Int{
        get{
            return Int(self.accessibilityIdentifier!)!
        }
        
        set{
            self.accessibilityIdentifier = String(newValue)
        }
    }
}
