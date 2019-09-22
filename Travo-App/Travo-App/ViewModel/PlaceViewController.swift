//
//  PlaceViewController.swift
//  Travo-App
//
//  Created by Gayuru Gunawardana on 15/9/19.
//  Copyright © 2019 Sogyal Thundup Sherpa. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Cosmos

class PlaceViewController: UIViewController {
    
    //this is how you should pass the data into the controller
//    detailViewController.contact = contacts[index]
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var placeOpenHours: UILabel!
    @IBOutlet weak var placeRating: CosmosView!
    @IBOutlet weak var placeWeather: UIImageView!
    @IBOutlet var placeFavourite: UIButton!
    
    var favourites : [Place]!
    var currentUser : User!
    var indexPass = String()
    var index:Int = 0
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backHome", sender: self)
    }
    
    var viewModel = PlacesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        index = viewModel.getIndex(title: indexPass)
        if currentUser.getFavourites().count <= 0{
            placeFavourite.setImage(UIImage(named: "heart"), for: .normal)
        }else{
            favourites = currentUser.getFavourites()
            getFavourite(name: viewModel.getTitleFor(index: index))
        }
        placeImage.contentMode = .scaleAspectFill
        placeTitle.text = viewModel.getTitleFor(index: index)
        placeDescription.text = viewModel.getDescFor(index: index)
        placeOpenHours.text = viewModel.getOpenTimeFor(index: index)
        placeImage.image = viewModel.getImageURLFor(index: index)
        placeRating.settings.updateOnTouch = false
        placeRating.settings.fillMode = .precise
        placeRating.rating = viewModel.getStarRating(index: index)
        placeRating.text = String(viewModel.getStarRating(index: index))
        placeWeather.image = viewModel.getWeather(index: index)
    }
    
    //head to google maps app
    @IBAction func visitButton(_ sender: Any) {
        //hardcoded for MELBOURNE
        let latitude: CLLocationDegrees = -37.8136
        let longitude: CLLocationDegrees = 144.9631
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel.getTitleFor(index: index)
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    func getFavourite(name:String){
        for place in favourites{
            if place.name == name{
                placeFavourite.setImage(UIImage(named:"like"), for: .normal)
            }
        }
    }
}

