//
//  PendingTableViewCell.swift
//  WagerMe
//
//  Created by chris calvert on 4/14/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.
//CODED BY CHRIS CALVERT

//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017,
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html

import UIKit

class PendingTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var headersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
