//
//  ViewController.swift
//  WagerMe
//
//  Created by Christopher calvert on 3/1/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY CHRIS CALVERT

import UIKit

class ViewController: UIViewController {
    
    
    var userInfo = [[String]]()
    
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userUsername: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func register(_ sender: Any) {
        let stuff = userInfo
        
        if(fullname.text!.isEmpty || userAge.text!.isEmpty || userUsername.text!.isEmpty || userEmail.text!.isEmpty || userPassword.text!.isEmpty) {
            
            let myAlert = UIAlertController(title: "Alert", message: "All fields are required to register.", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            
            return;
        }
        
        func validateAlpha(field: [String]) -> Bool {
            let alphanumericChars = NSCharacterSet(charactersIn: "!@#$%^&*()-_=+1234567890.,")
            
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
        
        func validateAge(field: [String]) -> Bool {
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
        
        func validateEmail(field: [String]) -> Bool {
            let alphanumericChars = NSCharacterSet(charactersIn: "!#$%^&*()-_=+,")
            
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
        
        func validate(field: [String]) -> Bool {
            let alphanumericChars = NSCharacterSet(charactersIn: "!@#$%^&*()-_=+")
            
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
        
        
        if validateAlpha(field: [fullname.text!]) {
            let validateName = UIAlertController(title: "Alert", message: "You have entered invalid characters in the 'Name' field", preferredStyle: UIAlertControllerStyle.alert)
            
            validateName.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validateName, animated: true, completion: nil)
            
        } else if validateAge(field: [userAge.text!]) {
            let validateAge = UIAlertController(title: "Alert", message: "You have entered non-numbers in the 'Age' field", preferredStyle: UIAlertControllerStyle.alert)
            
            validateAge.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validateAge, animated: true, completion: nil)
            
            
            
        } else if validate(field: [userUsername.text!]) {
            let validateUsername = UIAlertController(title: "Alert", message: "You have entered invalid characters in the 'Username' field", preferredStyle: UIAlertControllerStyle.alert)
            
            validateUsername.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validateUsername, animated: true, completion: nil)
        } else if validateEmail(field: [userEmail.text!]) {
            let validateEmail = UIAlertController(title: "Alert", message: "You have entered invalid characters in the 'Email' field", preferredStyle: UIAlertControllerStyle.alert)
            
            validateEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validateEmail, animated: true, completion: nil)
        } else if validate(field: [userPassword.text!]) {
            let validatePassword = UIAlertController(title: "Alert", message: "You have entered invalid characters in your password.", preferredStyle: UIAlertControllerStyle.alert)
            
            validatePassword.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(validatePassword, animated: true, completion: nil)
        } else if (fullname.text?.characters.count)! > 31 {
            let nameTooLong = UIAlertController(title: "Alert", message: "Your name must be less than 30 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            nameTooLong.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(nameTooLong, animated: true, completion: nil)
        } else if (fullname.text?.characters.count)! < 5 {
            let nameTooShort = UIAlertController(title: "Alert", message: "Your name must be greater than 4 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            nameTooShort.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(nameTooShort, animated: true, completion: nil)
        } else if (userPassword.text?.characters.count)! < 5 {
            let passwordTooShort = UIAlertController(title: "Alert", message: "Your password must be greater than 4 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            passwordTooShort.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(passwordTooShort, animated: true, completion: nil)
        } else if (userPassword.text?.characters.count)! > 19 {
            let passwordTooLong = UIAlertController(title: "Alert", message: "Your password must be less than 18 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            passwordTooLong.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(passwordTooLong, animated: true, completion: nil)
        } else if (userAge.text?.characters.count)! < 2 {
            let passwordTooLong = UIAlertController(title: "Alert", message: "Sorry! You're not old enough to register for WagerMe.", preferredStyle: UIAlertControllerStyle.alert)
            
            passwordTooLong.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(passwordTooLong, animated: true, completion: nil)
        } else if (userUsername.text?.characters.count)! > 21 {
            let usernameTooLong = UIAlertController(title: "Alert", message: "Your username must be less than 20 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            usernameTooLong.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(usernameTooLong, animated: true, completion: nil)
        } else if (userUsername.text?.characters.count)! < 5 {
            let usernameTooShort = UIAlertController(title: "Alert", message: "Your username must be greater than 4 characters.", preferredStyle: UIAlertControllerStyle.alert)
            
            usernameTooShort.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(usernameTooShort, animated: true, completion: nil)
            
        } else {
            
            
            
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team10/store.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(fullname.text!)&b=\(userAge.text!)&c=\(userUsername.text!)&d=\(userEmail.text!)&e=\(userPassword.text!)"
            
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
        
        let alertController = UIAlertController(title: "User", message: "User successfully registered!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        fullname.text = ""
        userAge.text = ""
        userEmail.text = ""
        userUsername.text = ""
        userPassword.text = ""
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:"http://cgi.soic.indiana.edu/~team10/pullUsers.php")
        do {
            let userdata = try Data(contentsOf: url!)
            
            let users = try JSONSerialization.jsonObject(with: userdata, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            if let jsonarray = users["users"] as? NSArray{
                for index in 0...jsonarray.count-1{
                    var array = [String]()
                    let object = jsonarray[index] as! [String : AnyObject]
                    let username = object["username"] as! String
                    let email = object["email"] as! String
                    
                    
                    array.append(username)
                    array.append(email)
                    userInfo.append(array)
                }
                
                
            }
        }
        catch{
        }
        print(userInfo)
        
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
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
}



