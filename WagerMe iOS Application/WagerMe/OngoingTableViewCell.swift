//
//  OngoingTableViewCell.swift
//  WagerMe
//
//  Created by chris calvert on 4/14/17.
//  Copyright © 2017 Christopher calvert. All rights reserved.

//How to make a table view
//Create a Table View. (2016, December 08). Retrieved April 20, 2017,
//    from https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html
//

import UIKit

class OngoingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var user1Button: UIButton!
    @IBOutlet weak var user2Button: UIButton!
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
