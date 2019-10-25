//
//  ViewInformationViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/12/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY STEVEN POULOS

import UIKit
import GoogleMobileAds

class ViewInformationViewController: UIViewController {
    
    @IBOutlet weak var userUsernameLabel: UILabel!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel2: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userUsername = UserDefaults.standard.string(forKey: "userUsername")!
        
        let fullname = UserDefaults.standard.string(forKey: "fullname")!
        
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        
        let id = UserDefaults.standard.string(forKey: "id")!
        
        let userAge = UserDefaults.standard.string(forKey: "userAge")!
        
        let balance = UserDefaults.standard.string(forKey: "balance")!
        
        userUsernameLabel2.text = userUsername
        userUsernameLabel.text = userUsername
        userNameLabel.text = fullname
        userAgeLabel.text = userAge
        userEmailLabel.text = userEmail
        userBalanceLabel.text = balance
        userIDLabel.text = id
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
