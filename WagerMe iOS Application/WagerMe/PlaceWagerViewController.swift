//
//  PlaceWagerViewController.swift
//  WagerMe
//
//  Created by Christopher calvert on 3/8/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY CHRIS CALVERT

import GoogleMobileAds
import UIKit

class PlaceWagerViewController: UIViewController{
    


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

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!

    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userBalance: UILabel!
    @IBOutlet weak var id2: UITextField!
    @IBOutlet weak var wager: UITextField!
    @IBOutlet weak var amount: UITextField!

    func validateCredits(field: [String]) -> Bool {
        let alphanumericChars = NSCharacterSet(charactersIn: "!@#$%^&*()-_=+.,abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        var result = false
        for x in field {
            if (x.rangeOfCharacter(from: alphanumericChars as CharacterSet) != nil) {
                result = true
            }
            else {
                result = false
            }
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsername.text = username
        
        let balance = UserDefaults.standard.string(forKey: "balance")!
        userBalance.text = (balance)
        
        // Do any additional setup after loading the view.
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlaceWagerViewController.dismissKeyboard))
        
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

    
    @IBAction func wagerPlaced(_ sender: Any) {
        
        if(id2.text!.isEmpty || wager.text!.isEmpty || amount.text!.isEmpty) {
            
            let myAlert = UIAlertController(title: "Wait!", message: "All fields are required to place a wager!", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            
            return;
            
        }
        
        if validateCredits(field: [amount.text!]) {
            let validateCredits = UIAlertController(title: "Hold On!", message: "You have entered an invalid entry in the 'Amount' field", preferredStyle: UIAlertControllerStyle.alert)
            
            validateCredits.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validateCredits, animated: true, completion: nil)
            
            return;
            
        }
        
        let balance = UserDefaults.standard.string(forKey: "balance")!
        if amount.text! > balance {
            //Create alert
            let alert = UIAlertController(title: "Oops", message: "That is more points than you have", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add action buttons to the alert
            alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the view
            self.present(alert, animated: true, completion: nil)
            
            
            
        } else{

        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team10/storeBets.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(userUsername.text!)&b=\(id2.text!)&c=\(wager.text!)&d=\(amount.text!)"
        
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
        }
        //Alert for successful registration
        
        let alertController = UIAlertController(title: "Congratulations!", message: "Your wager has been successfully placed! Check your Pending Wagers page to see if it gets accepted!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        id2.text = ""
        wager.text = ""
        amount.text = ""
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }





}
