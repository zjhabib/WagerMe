//
//  SettingsViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/8/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY CHRIS CALVERT

import UIKit
import GoogleMobileAds


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var userUsername: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsername.text = username

        // Do any additional setup after loading the view.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        //view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /// The banner view.
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
