//
//  UpdateUserViewController.swift
//  WagerMe
//
//  Created by steven poulos on 3/9/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY STEVEN POULOS

import UIKit
import GoogleMobileAds

class UpdatedUserViewController: UIViewController {
    
    
    
    @IBOutlet weak var userFullname: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var userUsernameTextLabel: UILabel!
    
    
    @IBAction func ConfirmUpdate(_ sender: Any) {
        
        
        
        if(userFullname.text!.isEmpty || userAge.text!.isEmpty || userEmail.text!.isEmpty || userPassword.text!.isEmpty) {
            
            let myAlert = UIAlertController(title: "Alert", message: "All fields are required to update.", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            
            return;
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateUser.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(userFullname.text!)&b=\(userAge.text!)&d=\(userEmail.text!)&e=\(userPassword.text!)"
        
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
        
        //Alert for successful registration
        
        let alertController = UIAlertController(title: "User", message: "User successfully updated!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
        userFullname.text = ""
        userAge.text = ""
        userEmail.text = ""

        userPassword.text = ""
        
        
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email = UserDefaults.standard.string(forKey: "userEmail")!
        userEmail.text = email
        let age = UserDefaults.standard.string(forKey: "userAge")!
        userAge.text = age
        let fullname = UserDefaults.standard.string(forKey: "fullname")!
        userFullname.text = fullname
        let password = UserDefaults.standard.string(forKey: "userPassword")!
        userPassword.text = password
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsernameTextLabel.text = username
        
        // Do any additional setup after loading the view.
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdatedUserViewController.dismissKeyboard))
        
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

