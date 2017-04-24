//
//  DeactivateViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/14/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY AUSTIN MOORE
//Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017,
//  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/

import UIKit

class DeactivateViewController: UIViewController {

    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userUsername = UserDefaults.standard.string(forKey: "userUsername")!
        let id = UserDefaults.standard.string(forKey: "id")!
        
        userUsernameLabel.text = userUsername
        userIDLabel.text = id

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deactivateButton(_ sender: Any) {
        
        //Deactivation alert
        let deactivationAlert = UIAlertController(title: "Wait!", message: "Are you sure you want to deactivate?", preferredStyle: UIAlertControllerStyle.alert)
        deactivationAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/deactivateAccount.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(self.userIDLabel.text!)"
            
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
        
        deactivationAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        // Present the alert to the view
        self.present(deactivationAlert, animated: true, completion: nil)
        
        let confirmationAlert = UIAlertController(title: "Bye", message: "We will miss you!", preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        })
        
        // Present the alert to the view
        confirmationAlert.addAction(OKAction)
        self.present(confirmationAlert, animated: true, completion: nil)
        
        
        

    }
    

}
