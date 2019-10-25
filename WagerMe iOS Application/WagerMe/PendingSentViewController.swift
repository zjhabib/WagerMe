//
//  PendingSentViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/13/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY CHRIS CALVERT AND AUSTIN MOORE
//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017,
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html

import UIKit
import GoogleMobileAds

class PendingSentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var pendingSentTable: UITableView!

    var list:[MyStruct] = [MyStruct]()
    
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
        
        
        pendingSentTable.dataSource = self
        pendingSentTable.delegate = self
        
        get_data("http://cgi.soic.indiana.edu/~team10/pendingSentWagers.php")
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
                if let data_betid = data_object["bet_id"] as? String,
                    let data_user1 = data_object["id"] as? String,
                    let data_user2 = data_object["id2"] as? String,
                    let data_wager = data_object["wager"] as? String,
                    let data_amount = data_object["amount"] as? String
                {
                    list.append(MyStruct(data_betid, data_user1, data_user2, data_wager, data_amount))
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
                self.pendingSentTable.reloadData()
                
        })
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pwscell", for: indexPath) as! PendingSentTableViewCell
        
        
        cell.infoLabel.text = list[indexPath.row].bet_id + "    " + list[indexPath.row].user1 + "   " +  list[indexPath.row].user2 + "   " + list[indexPath.row].wager + "    " +  list[indexPath.row].amount
        
        cell.headersLabel.text = "BetID   User 1   User 2   Wager   Amount"
        
        return cell
    }
    
    

}
