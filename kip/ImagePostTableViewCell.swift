//
//  ImagePostTableViewCell.swift
//  kip
//
//  Created by Kishan Patel on 1/14/17.
//  Copyright © 2017 Kishan Patel. All rights reserved.
//

import UIKit

class ImagePostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var postTimeLabel: UILabel!
    
    @IBOutlet weak var postProfileImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var upvotesLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postTextField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
