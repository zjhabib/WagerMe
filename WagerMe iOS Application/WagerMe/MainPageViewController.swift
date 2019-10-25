//
//  MainViewController.swift
//  WagerMe
//
//  Created by steven poulos on 4/4/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY STEVEN POULOS
// MODLED OFF Sergey Kargopolov
//Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017,
//  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userFullnameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let userUsername = UserDefaults.standard.string(forKey: "userUsername")!
        
        let fullname = UserDefaults.standard.string(forKey: "fullname")!
        
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        
        let id = UserDefaults.standard.string(forKey: "id")!
        
        let userAge = UserDefaults.standard.string(forKey: "userAge")!
        
        let balance = UserDefaults.standard.string(forKey: "balance")!
        
        userUsernameLabel.text = ("Username: " + userUsername)
        userFullnameLabel.text = ("Fullname: " + fullname)
        userAgeLabel.text = ("User Age: " + userAge)
        userEmailLabel.text = ("Email: " + userEmail)
        userBalanceLabel.text = ("Current Balance: " + balance)
        userIDLabel.text = ("User ID: " + id)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Calls this function when the tap is recognized.

        // Dispose of any resources that can be recreated.
    }
    
    
    
}
