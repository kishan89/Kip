//
//  PostTableViewCell.swift
//  kip
//
//  Created by Kishan Patel on 1/8/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var postUpvotesLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postUserLabel: UILabel!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
