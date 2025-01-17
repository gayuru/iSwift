//
//  FeelingLuckyViewController.swift
//  Travo-App
//
//  Created by Gayuru Gunawardana on 18/9/19.
//  Copyright © 2019 Sogyal Thundup Sherpa. All rights reserved.
//

import Foundation
import UIKit

class FeelingLuckyViewController: UIViewController {
    
    var viewModel:PlacesViewModel!
    let placeVC = PlaceViewController()
    var finishedAnimation:Bool = false
    @IBOutlet weak var btn: UIButton!
    @IBOutlet var bottomNav: UIView!
    var currentUser: UserCoreData?
    
    @IBAction func btnTapped(_ sender: Any) {
        //process the animation 
        UIView.animate(withDuration: 0.6,delay: 0,options: [.repeat, .autoreverse],
                           animations: {
                            self.btn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.btn.transform = CGAffineTransform.identity
                                self.finishedAnimation = true
                                if self.viewModel.feltLucky() != 0 {
                                    self.shouldPerformSegue(withIdentifier: "feltLucky", sender: self)
                                }
                            }
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.btn.layer.removeAllAnimations()
            self.finishedAnimation = false
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "feltLucky"){
            let secondController = segue.destination as! PlaceViewController
            secondController.viewModel = self.viewModel
            secondController.indexPass = viewModel.getTitleFor(index: viewModel.feltLucky())
            secondController.currentUser = currentUser
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "feltLucky") {
            if (finishedAnimation) {
                self.performSegue(withIdentifier: "feltLucky", sender: self)
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomNav.layer.cornerRadius = 10
        bottomNav.layer.masksToBounds = true
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func showLuckyView(segue:UIStoryboardSegue){}

}
