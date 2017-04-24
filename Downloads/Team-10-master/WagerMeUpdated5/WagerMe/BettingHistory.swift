//
//  BettingHistory.swift
//  WagerMe
//
//  Created by chris calvert on 4/10/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
// CODED BY STEVEN POULOS

//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017, 
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html

import UIKit

class BettingHistory: UITableView {
    var TableData:Array< String > = Array < String >()
    
    
    func viewDidLoad() {
        
        
        get_data_from_url("http://cgi.soic.indiana.edu/~team10/jsonArray.php")
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            self.extract_json(data!)
            
            
        })
        
        task.resume()
        
    }
    
    
    func extract_json(_ data: Data)
    {
        
        
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        
        if let bets_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let bets_obj = bets_list[i] as? NSDictionary
                {
                    if let user1_username = bets_obj["id"] as? String
                    {
                        if let user2_username = bets_obj["id2"] as? String
                        {
                            if let wager = bets_obj["wager"] as? String
                            {
                                if let amount = bets_obj["amount"] as? String
                                {
                                    TableData.append(user1_username + " " + user2_username + " " + wager + " " + amount)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        reloadData()
        
    }
    
    
}


