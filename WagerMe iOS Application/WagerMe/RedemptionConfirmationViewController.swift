//
//  RedemptionConfirmationViewController.swift
//  WagerMe
//
//  Created by chris calvert on 4/10/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY CHIRS CALVERT

import UIKit
import GoogleMobileAds

class RedemptionConfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var redeemedTable: UITableView!

    var list:[MyStruct] = [MyStruct]()
    
    struct MyStruct
    {
        var redemptionid = ""
        var prizetype = ""

        
        init(_ redemptionid:String, _ prizetype:String)
        {
            self.redemptionid = redemptionid
            self.prizetype = prizetype

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
        
        
        redeemedTable.dataSource = self
        redeemedTable.delegate = self
        
        get_data("http://cgi.soic.indiana.edu/~team10/redemptionHistory.php")
        
        
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
                if let data_redemptionid = data_object["redemptionid"] as? String,
                    let data_prizetype = data_object["prizetype"] as? String
                {
                    list.append(MyStruct(data_redemptionid, data_prizetype))
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
                self.redeemedTable.reloadData()
                
        })
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemed", for: indexPath) as! RedemptionTableViewCell
        
        
        cell.infoLabel.text = list[indexPath.row].redemptionid + "                " +  list[indexPath.row].prizetype
        cell.headersLabel.text = "Confirmation #         Prize"
    
        
        return cell
    }
    
    
    
}

