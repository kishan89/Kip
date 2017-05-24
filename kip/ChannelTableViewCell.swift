//
//  ChannelTableViewCell.swift
//  kip
//
//  Created by Kishan Patel on 1/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var memberCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
