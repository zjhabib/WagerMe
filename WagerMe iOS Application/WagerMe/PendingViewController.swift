//
//  PendingViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/12/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY AUSTIN MOORE AND CHRIS CALVERT

//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017,
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html

import UIKit
import GoogleMobileAds

class PendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var pendingTable: UITableView!
    
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
        
        init(_ bet_id:String, _ user1:String, _ user2:String, _ wager:String, _ amount:String)
        {
            self.bet_id = bet_id
            self.user1 = user1
            self.user2 = user2
            self.wager = wager
            self.amount = amount
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
        
        
        pendingTable.dataSource = self
        pendingTable.delegate = self
        
        get_data("http://cgi.soic.indiana.edu/~team10/pendingWagers.php")
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
                    let data_amount = data_object["amount"] as? String
                {
                    list.append(MyStruct(data_betid, data_user1, data_user2, data_wager, data_amount))
                    new_array.append(data_betid)
                    new_array.append(data_user1)
                    new_array.append(data_user2)
                    new_array.append(data_wager)
                    new_array.append(data_amount)
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
                self.pendingTable.reloadData()
                
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
        
        let cell = self.pendingTable.dequeueReusableCell(withIdentifier: "pwcell", for: indexPath) as! PendingTableViewCell
        
        cell.infoLabel.text = list[indexPath.row].bet_id + "    " + list[indexPath.row].user1 + "   " +  list[indexPath.row].user2 + "   " + list[indexPath.row].wager + "    " + list[indexPath.row].amount

        cell.headersLabel.text = "BetID   User 1   User 2   Wager   Amount"
        
        //cell.acceptButton.tag = indexPath.row
        //cell.acceptButton.addTarget(self, action: #selector(PendingViewController.acceptAction), for: .touchUpInside)
        
        //cell.declineButton.tag = indexPath.row
        //cell.declineButton.addTarget(self, action: #selector(PendingViewController.declineAction), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let acceptAlert = UIAlertController(title: "Wait a second!", message: "Are you sure you want to accept this wager?", preferredStyle: UIAlertControllerStyle.alert)
        acceptAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
            var betid = self.temp_array[indexPath.row][0]
            var user1 = self.temp_array[indexPath.row][1]
            var user2 = self.temp_array[indexPath.row][2]
            var desc = self.temp_array[indexPath.row][3]
            var amt = self.temp_array[indexPath.row][4]
            print("++++++")
            print(betid)
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/acceptWager.php")! as URL)
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
            
                    self.performSegue(withIdentifier: "pendingseg", sender: self)
            
            //let acceptConfirmationAlert = UIAlertController(title: "Congratulations!", message: "You have successfully accepted this wager!", preferredStyle: UIAlertControllerStyle.alert)
            //acceptConfirmationAlert.addAction(UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.default, handler: nil))
            //self.present(acceptConfirmationAlert, animated: true, completion: nil)
            
        }))
        acceptAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {action in
            var betid = self.temp_array[indexPath.row][0]
            var user1 = self.temp_array[indexPath.row][1]
            var user2 = self.temp_array[indexPath.row][2]
            var desc = self.temp_array[indexPath.row][3]
            var amt = self.temp_array[indexPath.row][4]
            print("++++++")
            print(betid)
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://cgi.soic.indiana.edu/~team10/declineWager.php")! as URL)
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

            self.performSegue(withIdentifier: "pendingseg", sender: self)
        }))
        acceptAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(acceptAlert, animated: true, completion: nil)
    }

    
   /* @IBAction func acceptAction(sender: UIButton) {
        
        
        let acceptAlert = UIAlertController(title: "Wait a second!", message: "Are you sure you want to accept this wager?", preferredStyle: UIAlertControllerStyle.alert)
        acceptAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
  
            let acceptConfirmationAlert = UIAlertController(title: "Congratulations!", message: "You have successfully accepted this wager!", preferredStyle: UIAlertControllerStyle.alert)
            acceptConfirmationAlert.addAction(UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.default, handler: nil))
            self.present(acceptConfirmationAlert, animated: true, completion: nil)
        
        }))
        acceptAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(acceptAlert, animated: true, completion: nil)
        
    }*/
    
    /*@IBAction func declineAction(sender: UIButton) {
        
        let declineAlert = UIAlertController(title: "Wait a second!", message: "Are you sure you want to decline this wager?", preferredStyle: UIAlertControllerStyle.alert)
        declineAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
            //PHP and connection with database to post bet_ID and update `Status` of bet
            
            let declineConfirmationAlert = UIAlertController(title: "Aw Man!", message: "You have unfortunately declined this wager!", preferredStyle: UIAlertControllerStyle.alert)
            declineConfirmationAlert.addAction(UIAlertAction(title: "Maybe Next Time!", style: UIAlertActionStyle.default, handler: nil))
            self.present(declineConfirmationAlert, animated: true, completion: nil)
            
        }))
        declineAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(declineAlert, animated: true, completion: nil)
       */
    //}
    
    
}

