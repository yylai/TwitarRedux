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
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWith(tweet.profileUrl!)
            nameLabel.text = tweet.name!
            screenNameLabel.text = tweet.screenName!
            let formatter = DateFormatter()
            formatter.dateStyle = .short
        
            
            let interval = -tweet.timeStamp!.timeIntervalSinceNow
            let seconds = Int(interval.rounded(.towardZero))
            let minutes = Int((interval / 60).rounded(.towardZero))
            let hours = Int((interval / 3600).rounded(.towardZero))
            
            if seconds <= 60 {
                timeSinceLabel.text = "\(seconds)s"
            } else if minutes <= 60 {
                timeSinceLabel.text = "\(minutes)m"
            } else if hours <= 23 {
                timeSinceLabel.text = "\(hours)h"
            } else {
                 timeSinceLabel.text = formatter.string(from: tweet.timeStamp!)
            }
            
            tweetTextLabel.text = tweet.text!
            
            retweetLabel.text = String(tweet.retweetCount)
            favLabel.text = String(tweet.favCount)
            
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
