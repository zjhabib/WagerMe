//
//  LoginViewController.swift
//  WagerMe
//
//  Created by Christopher calvert on 3/2/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY STEVEN POULOS
// FOLOWED TUTORIAL FROM Sergey Kargopolov
//Complete Login and Registration System in PHP and MYSQL. (2017, April 18). Retrieved April 20, 2017, 
//  from https://www.udemy.com/login-and-registration-system-in-php-and-mysql-step-by-step/



import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userUsernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        let userUsername = userUsernameTextField.text
        let userPassword = userPasswordTextField.text
        
        if(userUsername!.isEmpty || userPassword!.isEmpty) {
            //THROWS AN ALERT IF NO ENTRIES ARE ENTERED
            let myAlert = UIAlertController(title: "Alert", message: "All fields are required to login.", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            
            return;
        }
        
        let myUrl = URL(string: "https://cgi.soic.indiana.edu/~team10/userLogin.php");
        
        
        //POST REQUEST THAT TAKES THE USERS USERNAME AND PASSWORD AND SENDS THEM TO A PHP AND CHECKS CREDENTIALS AND THEN RETURNS VALUES THAT ARE PARSED AND STORED AS USERDEFAULTS
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        
        let postString = "username=\(userUsername!)&password=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            DispatchQueue.main.async
                {
                    
                    
                    
                    
                    if(error != nil)
                    {
                        //Display an alert message
                        let myAlert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated: true, completion: nil)
                        return
                    }
                    
                    
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            
                            let userId = parseJSON["id"] as? String
                            if(userId != nil)
                            {
                                
                                UserDefaults.standard.set(parseJSON["userUsername"], forKey: "userUsername")
                                UserDefaults.standard.set(parseJSON["fullname"], forKey: "fullname")
                                UserDefaults.standard.set(parseJSON["userEmail"], forKey: "userEmail")
                                UserDefaults.standard.set(parseJSON["id"], forKey: "id")
                                UserDefaults.standard.set(parseJSON["userAge"], forKey: "userAge")
                                UserDefaults.standard.set(parseJSON["balance"], forKey: "balance")
                                UserDefaults.standard.set(parseJSON["userPassword"], forKey: "userPassword")
                                
                                
                                UserDefaults.standard.synchronize()
                                
                                //THIS TAKES YOU TO THE NAV MAIN PAGE THAT YOU ARE SHOWN YOUR INFORMATION
                                let mainPage = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
                                
                                let mainPageNav = UINavigationController(rootViewController: mainPage)
                                let appDelegate = UIApplication.shared.delegate
                                
                                appDelegate?.window??.rootViewController = mainPageNav
                                
                            } else {
                                // display an alert message
                                let userMessage = parseJSON["message"] as? String
                                let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                                myAlert.addAction(okAction);
                                self.present(myAlert, animated: true, completion: nil)
                            }
                            
                        }
                    } catch
                    {
                        print(error)
                    }
                    
                    
            }
            
            
            
        }
        
        task.resume()
        
    }
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        
    }
    
}



