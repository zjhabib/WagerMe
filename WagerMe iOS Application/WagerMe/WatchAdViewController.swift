//
//  WatchAdViewController.swift
//  WagerMe
//
//  Created by Habib, Zane Jordan on 4/18/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//

//Get Started  |  AdMob by Google  |  Firebase. (n.d.). Retrieved April 20, 2017, 
//  from https://firebase.google.com/docs/admob/ios/quick-start

//Interstitial Ads  |  AdMob by Google  |  Firebase. (n.d.). Retrieved April 20, 2017, 
//  from https://firebase.google.com/docs/admob/ios/interstitial


import UIKit
import GoogleMobileAds

class WatchAdViewController: UIViewController, UIAlertViewDelegate {
    var interstitial: GADInterstitial!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var userUsername: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/2934735716")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
        
        /// The banner view.
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let currentbalance = UserDefaults.standard.string(forKey: "balance")!
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        
        userUsername.text = username
        
        currentBalance.text = currentbalance
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func showAds(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {//Create alert
            let alert = UIAlertController(title: "Sorry", message: "You are only allowed to watch advertisements for points once!", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add action buttons to the alert
            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
            let Ad2Points = Int(currentbalance)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateBalanceVideoad2.php")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "a=\(self.userUsername.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    UserDefaults.standard.set(Ad2Points, forKey:"balance")
                    
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    print("response = \(String(describing: response))")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                }
                task.resume()
            }))
            
            // Present the alert to the view
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    @IBAction func VideoAdTapped(_ sender: Any) {
        let currentbalance = UserDefaults.standard.integer(forKey: "balance")
        let AdPoints = Int(currentbalance + 5)
        
        if currentbalance < 246 {
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateBalanceVideoad.php")! as URL)
            
            request.httpMethod = "POST"
            
            let postString = "a=\(self.userUsername.text!)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                UserDefaults.standard.set(AdPoints, forKey:"balance")
                
                if error != nil {
                    print("error=\(String(describing: error))")
                    return
                }
                
                print("response = \(String(describing: response))")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        }
        else {//Create alert
            let alert = UIAlertController(title: "Sorry", message: "You have reached the limit of 250 WagerPoints!", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add action buttons to the alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the view
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
