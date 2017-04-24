//
//  MenuViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/8/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY CHRIS CALVERT

import UIKit
import GoogleMobileAds

class MenuViewController: UIViewController {
   
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var userUsernameTextLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var currentBalance: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if(profilePhotoImageView.image == nil)
        {
            let userId = UserDefaults.standard.string(forKey: "id")
            let imageUrl = URL(string:"https://cgi.soic.indiana.edu/~team10/profile-pictures/\(userId!)/user-profile.jpg")
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                
                let imageData = try? Data(contentsOf: imageUrl!)
                
                if(imageData != nil)
                {
                    DispatchQueue.main.async(execute: {
                        self.profilePhotoImageView.image = UIImage(data: imageData!)
                    })
                }
                
            }
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsernameTextLabel.text = username
        
        let currentbalance = UserDefaults.standard.string(forKey: "balance")!
        currentBalance.text = currentbalance

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
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
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    


}
