//
//  MarketplaceViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/8/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY ZANE HABIB

import UIKit
import GoogleMobileAds

class MarketplaceViewController: UIViewController {
   
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var currentBalance: UILabel!
    
    @IBOutlet weak var userUsername: UILabel!
    
    @IBAction func AmexTapped(_ sender: Any) {
        
        let currentbalance = UserDefaults.standard.integer(forKey: "balance")
        let AmexPoints = Int(currentbalance - 25)
        if(currentbalance<25){
            let myAlert = UIAlertController(title: "Alert", message: "You do not have enough WagerPoints to redeem this prize!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion: nil)
            return;
        } else {
            let acceptAmexAlert = UIAlertController(title: "Hang on!", message: "Are you sure you want to redeem this prize?", preferredStyle: .alert)
            acceptAmexAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemAmexPrize.php")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "a=\(self.userUsername.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    UserDefaults.standard.set(AmexPoints, forKey:"balance")
                    
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    print("response = \(String(describing: response))")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                }
                task.resume()
                let amexAlert = UIAlertController(title: "Congrats!", message: "You have successfully redeemed this prize! Please visit your 'Redeemed Prizes' table to view all of the prizes you've redeemed!", preferredStyle: .alert)
                amexAlert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: {action in
                    let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemAmexPrize2.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.userUsername.text!)"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
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
                self.present(amexAlert, animated: true, completion: nil)

            }))
            acceptAmexAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(acceptAmexAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func PotleTapped(_ sender: Any) {
        let currentbalance = UserDefaults.standard.integer(forKey: "balance")
        let PotlePoints = Int(currentbalance - 10)
        if(currentbalance<10){
            let myAlert = UIAlertController(title: "Alert", message: "You do not have enough WagerPoints to redeem this prize!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion: nil)
            return;
        } else {
            let acceptPotleAlert = UIAlertController(title: "Hang on!", message: "Are you sure you want to redeem this prize?", preferredStyle: .alert)
            acceptPotleAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeem/PotlePrize.php")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "a=\(self.userUsername.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    UserDefaults.standard.set(PotlePoints, forKey:"balance")
                    
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    print("response = \(String(describing: response))")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                }
                task.resume()
                let potleAlert = UIAlertController(title: "Congrats!", message: "You have successfully redeemed this prize! Please visit your 'Redeemed Prizes' table to view all of the prizes you've redeemed!", preferredStyle: .alert)
                potleAlert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: {action in
                    let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemPotlePrize2.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.userUsername.text!)"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
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
                self.present(potleAlert, animated: true, completion: nil)
                
            }))
            acceptPotleAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(acceptPotleAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func RoysTapped(_ sender: Any) {
        let currentbalance = UserDefaults.standard.integer(forKey: "balance")
        let RoysPoints = Int(currentbalance - 15)
        if(currentbalance<15){
            let myAlert = UIAlertController(title: "Alert", message: "You do not have enough WagerPoints to redeem this prize!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion: nil)
            return;
        } else {
            let acceptRoysAlert = UIAlertController(title: "Hang on!", message: "Are you sure you want to redeem this prize?", preferredStyle: .alert)
            acceptRoysAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemRoysPrize.php")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "a=\(self.userUsername.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    UserDefaults.standard.set(RoysPoints, forKey:"balance")
                    
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    print("response = \(String(describing: response))")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                }
                task.resume()
                let roysAlert = UIAlertController(title: "Congrats!", message: "You have successfully redeemed this prize! Please visit your 'Redeemed Prizes' table to view all of the prizes you've redeemed!", preferredStyle: .alert)
                roysAlert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: {action in
                    let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemRoysPrize2.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.userUsername.text!)"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
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
                self.present(roysAlert, animated: true, completion: nil)
                
            }))
            acceptRoysAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(acceptRoysAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func ItunesTapped(_ sender: Any) {
        let currentbalance = UserDefaults.standard.integer(forKey: "balance")
        let ItunesPoints = Int(currentbalance - 20)
        if(currentbalance<20){
            let myAlert = UIAlertController(title: "Alert", message: "You do not have enough WagerPoints to redeem this prize!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated:true, completion: nil)
            return;
        } else {
            let acceptItunesAlert = UIAlertController(title: "Hang on!", message: "Are you sure you want to redeem this prize?", preferredStyle: .alert)
            acceptItunesAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemItunesPrize.php")! as URL)
                
                request.httpMethod = "POST"
                
                let postString = "a=\(self.userUsername.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    UserDefaults.standard.set(ItunesPoints, forKey:"balance")
                    
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    print("response = \(String(describing: response))")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                }
                task.resume()
                let itunesAlert = UIAlertController(title: "Congrats!", message: "You have successfully redeemed this prize! Please visit your 'Redeemed Prizes' table to view all of the prizes you've redeemed!", preferredStyle: .alert)
                itunesAlert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: {action in
                    let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/redeemItunesPrize2.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.userUsername.text!)"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
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
                self.present(itunesAlert, animated: true, completion: nil)
                
            }))
            acceptItunesAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(acceptItunesAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentbalance = UserDefaults.standard.string(forKey: "balance")!
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        
        userUsername.text = username
        
        currentBalance.text = ("You currently have " + currentbalance + " WagerPoints!")
        
        // AdMob Code
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
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
