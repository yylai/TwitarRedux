//
//  TweetCell.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/30/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWith(tweet.profileUrl!)
            nameLabel.text = tweet.name!
            screenNameLabel.text = tweet.screenName!
            timeSinceLabel.text = "123m"
            tweetTextLabel.text = tweet.text!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
