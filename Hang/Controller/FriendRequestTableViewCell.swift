//
//  FriendRequestTableViewCell.swift
//  Hang
//
//  Created by Andrew Sibert on 5/1/18.
//  Copyright © 2018 Ben Hylak. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestEmoji: UILabel!
    
    @IBOutlet weak var requesterName: UILabel!
    
    @IBOutlet weak var requestDetails: UILabel!
    
    @IBOutlet weak var requestActionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
