//
//  FriendsTableViewCell.swift
//  hang
//
//  Created by Joe Kennedy on 4/24/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var emoji: UILabel!
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    
<<<<<<< HEAD
=======
    @IBOutlet weak var checkAccessory: UIButton!
>>>>>>> 3a7340f837ff77967126cd90ac6ec67658bbb2c5
    @IBOutlet weak var available: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
