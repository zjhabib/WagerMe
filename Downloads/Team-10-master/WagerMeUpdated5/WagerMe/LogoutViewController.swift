//
//  LogoutViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/8/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY AUSTIN MOORE
//Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017,
//  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/

import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet weak var userUsernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsernameLabel.text = username

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userUsername")
        UserDefaults.standard.removeObject(forKey: "fullname")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "userAge")
        UserDefaults.standard.removeObject(forKey: "balance")
        UserDefaults.standard.synchronize()

    }
    

}
