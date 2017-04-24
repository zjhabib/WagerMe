//
//  OngoingViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/12/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY AUSTIN MOORE

//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017,
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html

import UIKit
import GoogleMobileAds

class OngoingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var ongoingTable: UITableView!
    
    var temp_num = 0
    
    
    var list:[MyStruct] = [MyStruct]()
    
    var temp_array = [[String]]()
    
    struct MyStruct
    {
        var bet_id = ""
        var user1 = ""
        var user2 = ""
        var wager = ""
        var amount = ""
        var result1 = ""
        var result2 = ""
        var outcome1 = ""
        var outcome2 = ""
        
        
        init(_ bet_id:String, _ user1:String, _ user2:String, _ wager:String, _ amount:String, _ result1:String, _ result2:String, _ outcome1:String, _ outcome2:String)
        {
            self.bet_id = bet_id
            self.user1 = user1
            self.user2 = user2
            self.wager = wager
            self.amount = amount
            self.result1 = result1
            self.result2 = result2
            self.outcome1 = outcome1
            self.outcome2 = outcome2
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let username = UserDefaults.standard.string(forKey: "userUsername")!
        userUsernameLabel.text = username
        
        
        /// The banner view.
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        ongoingTable.dataSource = self
        ongoingTable.delegate = self
        
        get_data("http://cgi.soic.indiana.edu/~team10/ongoingWagers.php")
    }
    
    
    func get_data(_ link:String)
    {
        let url:URL = URL(string: link)!
        
        
        var request = URLRequest(url:url);
        request.httpMethod = "POST";
        
        
        let postString = "a=\(userUsernameLabel.text!)";
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            
            self.extract_data(data)
            
        }
        
        task.resume()
    }
    
    
    func extract_data(_ data:Data?)
    {
        let json:Any?
        
        if(data == nil)
        {
            return
        }
        
        do{
            json = try JSONSerialization.jsonObject(with: data!, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_array = json as? NSArray else
        {
            return
        }
        
        
        for i in 0 ..< data_array.count
        {
            if let data_object = data_array[i] as? NSDictionary
            {
                var new_array = [String]()
                if let data_betid = data_object["bet_id"] as? String,
                    let data_user1 = data_object["id"] as? String,
                    let data_user2 = data_object["id2"] as? String,
                    let data_wager = data_object["wager"] as? String,
                    let data_amount = data_object["amount"] as? String,
                    let data_result1 = data_object["result1"] as? String,
                    let data_result2 = data_object["result2"] as? String,
                    let data_outcome1 = data_object["outcome1"] as? String,
                    let data_outcome2 = data_object["outcome2"] as? String
                {
                    list.append(MyStruct(data_betid, data_user1, data_user2, data_wager, data_amount, data_result1, data_result2, data_outcome1, data_outcome2))
                    new_array.append(data_betid)
                    new_array.append(data_user1)
                    new_array.append(data_user2)
                    new_array.append(data_wager)
                    new_array.append(data_amount)
                    new_array.append(data_result1)
                    new_array.append(data_result2)
                    new_array.append(data_outcome1)
                    new_array.append(data_outcome2)
                    self.temp_array.append(new_array)
                }
                
            }
        }
        
        
        refresh_now()
        
        
    }
    
    func refresh_now()
    {
        DispatchQueue.main.async(
            execute:
            {
                self.ongoingTable.reloadData()
                
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.ongoingTable.dequeueReusableCell(withIdentifier: "owcell", for: indexPath) as! OngoingTableViewCell
        
        cell.infoLabel.text = list[indexPath.row].bet_id + "   " + list[indexPath.row].user1 + "   " +  list[indexPath.row].user2 + "   " + list[indexPath.row].wager + "   " + list[indexPath.row].amount
        
        cell.headersLabel.text = "BetID   User 1   User 2   Wager   Amount"
        
        //cell.user1Button.tag = indexPath.row
        //cell.user1Button.addTarget(self, action: #selector(OngoingViewController.user1Action), for: .touchUpInside)
        
        //cell.user2Button.tag = indexPath.row
        //cell.user2Button.addTarget(self, action: #selector(OngoingViewController.user2Action), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var betid = self.temp_array[indexPath.row][0]
        var out1 = self.temp_array[indexPath.row][7]
        var out2 = self.temp_array[indexPath.row][8]
        let out1int = Int(out1)
        let out2int = Int(out2)
        let one = 1
        
        if out1int == one && out2int == one {
            
            //Create alert
            let alert = UIAlertController(title: "Bet Complete", message: "This bet has been completed. Bet information can be found in Bet History", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add action buttons to the alert
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(betid)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                    
                    print("response = \(response)")
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(responseString)")
                }
                task.resume()
                self.performSegue(withIdentifier: "ongoingseg", sender: self)
            }))
            
            // Present the alert to the view
            self.present(alert, animated: true, completion: nil)
            
            
        }
            
        else{
            let acceptAlert = UIAlertController(title: "Wager Complete!", message: "Who won your Wager?", preferredStyle: UIAlertControllerStyle.alert)
            acceptAlert.addAction(UIAlertAction(title: "User1", style: UIAlertActionStyle.default, handler: { action in
                
                let zero = 0
                let one = 1
                let two = 2
                let username = UserDefaults.standard.string(forKey: "userUsername")
                var betid = self.temp_array[indexPath.row][0]
                var user1 = self.temp_array[indexPath.row][1]
                var user2 = self.temp_array[indexPath.row][2]
                var desc = self.temp_array[indexPath.row][3]
                var amt = self.temp_array[indexPath.row][4]
                var res1 = self.temp_array[indexPath.row][5]
                var res2 = self.temp_array[indexPath.row][6]
                let res1int = Int(res1)
                let res2int = Int(res2)
                let amtInt = Int(amt)
                
                
                if username == user1 {
                    
                    if res1int == zero && res2int == zero || res1int == zero && res2int != zero {
                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateResult1.php")! as URL)
                        request.httpMethod = "POST"
                        
                        let postString = "a=\(betid)"
                        
                        request.httpBody = postString.data(using: String.Encoding.utf8)
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(error)")
                                return
                            }
                            
                            print("response = \(response)")
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("responseString = \(responseString)")
                        }
                        task.resume()
                        
                        //Create alert
                        let alert = UIAlertController(title: "Wager Updated!", message: "Press bet again to check status", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Add action buttons to the alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            self.performSegue(withIdentifier: "ongoingseg", sender: self)}))
                        
                        // Present the alert to the view
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                        
                    else {
                        let acceptConfirmationAlert = UIAlertController(title: "Wait!", message: "You have already selected a winner. Click okay to check wager status.", preferredStyle: UIAlertControllerStyle.alert)
                        acceptConfirmationAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            
                            if username == user1 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
                            }//bracket for end of asking if username == user1 for check wager status
                                
                            else if username == user2 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points.", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }//bracket for end of asking if username == user2 for check wager status
                            
                        }))//end of user1 "Okay"
                        self.present(acceptConfirmationAlert, animated: true, completion: nil)
                        
                    }
                    
                } //bracket to end username == user1
                    
                else if username == user2 {
                    
                    if res1int == zero && res2int == zero || res1int != zero && res2int == zero {
                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateResult2Win.php")! as URL)
                        request.httpMethod = "POST"
                        
                        let postString = "a=\(betid)"
                        
                        request.httpBody = postString.data(using: String.Encoding.utf8)
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(error)")
                                return
                            }
                            
                            print("response = \(response)")
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("responseString = \(responseString)")
                        }
                        task.resume()
                        
                        //Create alert
                        let alert = UIAlertController(title: "Wager Updated!", message: "Press bet again to check status", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Add action buttons to the alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            self.performSegue(withIdentifier: "ongoingseg", sender: self)}))
                        
                        // Present the alert to the view
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                        
                    else {
                        let acceptConfirmationAlert = UIAlertController(title: "Wait!", message: "You have already selected a winner. Click okay to check wager status.", preferredStyle: UIAlertControllerStyle.alert)
                        acceptConfirmationAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            
                            if username == user1 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
                            }//bracket for end of asking if username == user1 for check wager status
                                
                            else if username == user2 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points.", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }//bracket for end of asking if username == user2 for check wager status
                            
                        }))//end of user1 "Okay"
                        self.present(acceptConfirmationAlert, animated: true, completion: nil)
                        
                    }
                    
                }//bracket to end username == user2
                
            }))
            acceptAlert.addAction(UIAlertAction(title: "User2", style: UIAlertActionStyle.default, handler: {action in
                
                let zero = 0
                let one = 1
                let two = 2
                let username = UserDefaults.standard.string(forKey: "userUsername")
                var betid = self.temp_array[indexPath.row][0]
                var user1 = self.temp_array[indexPath.row][1]
                var user2 = self.temp_array[indexPath.row][2]
                var desc = self.temp_array[indexPath.row][3]
                var amt = self.temp_array[indexPath.row][4]
                var res1 = self.temp_array[indexPath.row][5]
                var res2 = self.temp_array[indexPath.row][6]
                let res1int = Int(res1)
                let res2int = Int(res2)
                let amtInt = Int(amt)
                
                if username == user1 {
                    
                    if res1int == zero && res2int == zero || res1int == zero && res2int != zero {
                        
                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateResult1User2.php")! as URL)
                        request.httpMethod = "POST"
                        
                        let postString = "a=\(betid)"
                        
                        request.httpBody = postString.data(using: String.Encoding.utf8)
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(error)")
                                return
                            }
                            
                            print("response = \(response)")
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("responseString = \(responseString)")
                        }
                        task.resume()
                        
                        //Create alert
                        let alert = UIAlertController(title: "Wager Updated!", message: "Press bet again to check status", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Add action buttons to the alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            self.performSegue(withIdentifier: "ongoingseg", sender: self)}))
                        
                        // Present the alert to the view
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                        
                    else{
                        let acceptConfirmationAlert = UIAlertController(title: "Wait!", message: "You have already selected a winner. Click okay to check wager status.", preferredStyle: UIAlertControllerStyle.alert)
                        acceptConfirmationAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            
                            if username == user1 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
                            }//bracket for end of asking if username == user1 for check wager status
                                
                            else if username == user2 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points.", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome1.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }//bracket for end of asking if username == user2 for check wager status
                            
                            
                            
                        }))//end of user2 okay
                        self.present(acceptConfirmationAlert, animated: true, completion: nil)
                        
                    }
                    
                } //bracket to end username == user1
                    
                else if username == user2 {
                    
                    if res1int == zero && res2int == zero || res1int != zero && res2int == zero {
                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateResult2User2.php")! as URL)
                        request.httpMethod = "POST"
                        
                        let postString = "a=\(betid)"
                        
                        request.httpBody = postString.data(using: String.Encoding.utf8)
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                print("error=\(error)")
                                return
                            }
                            
                            print("response = \(response)")
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("responseString = \(responseString)")
                        }
                        task.resume()
                        
                        //Create alert
                        let alert = UIAlertController(title: "Wager Updated!", message: "Press bet again to check status", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Add action buttons to the alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            self.performSegue(withIdentifier: "ongoingseg", sender: self)}))
                        
                        // Present the alert to the view
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                        
                    else{
                        let acceptConfirmationAlert = UIAlertController(title: "Wait", message: "You have already selected a winner. Click okay to check wager status.", preferredStyle: UIAlertControllerStyle.alert)
                        acceptConfirmationAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                            
                            if username == user1 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user1)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
                            }//bracket for end of asking if username == user1 for check wager status
                                
                            else if username == user2 {
                                
                                if res1int == one && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Oh no!", message: "You lost the bet.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/subtractWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance - amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of winner if
                                    
                                else if res1int == two && res2int == two {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Give me my points.", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/addWagerpoints.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(user2)&b=\(amt)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            let currentbalance = UserDefaults.standard.integer(forKey: "balance")
                                            let newBalance = Int(currentbalance + amtInt!)
                                            UserDefaults.standard.set(newBalance, forKey:"balance")
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        
                                        //Create alert
                                        let alert = UIAlertController(title: "Wager Successful", message: "Your balance has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        // Add action buttons to the alert
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
                                            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updateOutcome2.php")! as URL)
                                            request.httpMethod = "POST"
                                            
                                            let postString = "a=\(betid)"
                                            
                                            request.httpBody = postString.data(using: String.Encoding.utf8)
                                            
                                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                                data, response, error in
                                                
                                                if error != nil {
                                                    print("error=\(error)")
                                                    return
                                                }
                                                
                                                print("response = \(response)")
                                                
                                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                print("responseString = \(responseString)")
                                            }
                                            task.resume()
                                            self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                        }))
                                        
                                        // Present the alert to the view
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of loser if
                                    
                                else if res1int == one && res2int == two || res1int == two && res2int == one {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Sorry", message: "Someone was dishonest", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Terminate Bet", style: UIAlertActionStyle.default, handler: {action in
                                        let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/updatePast.php")! as URL)
                                        request.httpMethod = "POST"
                                        
                                        let postString = "a=\(betid)"
                                        
                                        request.httpBody = postString.data(using: String.Encoding.utf8)
                                        
                                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                            data, response, error in
                                            
                                            if error != nil {
                                                print("error=\(error)")
                                                return
                                            }
                                            
                                            print("response = \(response)")
                                            
                                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                            print("responseString = \(responseString)")
                                        }
                                        task.resume()
                                        self.performSegue(withIdentifier: "ongoingseg", sender: self)
                                    }))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }//bracket for end of dishonest if
                                    
                                else {
                                    
                                    //Create alert
                                    let alert = UIAlertController(title: "Wait!", message: "Opponent hasn't confirmed. Check back later.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // Add action buttons to the alert
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    // Present the alert to the view
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }//bracket for end of asking if username == user2 for check wager status
                            
                            
                            
                        }))//end of user2 okay
                        self.present(acceptConfirmationAlert, animated: true, completion: nil)
                        
                    }
                    
                }//bracket to end username == user2
                
            }))
            acceptAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(acceptAlert, animated: true, completion: nil)
            
        }
        
    }
    
}



