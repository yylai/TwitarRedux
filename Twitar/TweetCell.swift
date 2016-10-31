//
//  TweetCell.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/30/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetCellDelegate {
    @objc optional func reply(tweetCell: TweetCell, replyTweet: Tweet)
}

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var delegate: TweetCellDelegate?
    
    
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
        
        let replyTapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.replyTapped))
        replyImageView.isUserInteractionEnabled = true
        replyImageView.addGestureRecognizer(replyTapGestureRecognizer)
        
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.retweetTapped))
        retweetImageView.isUserInteractionEnabled = true
        retweetImageView.addGestureRecognizer(retweetTapGestureRecognizer)
        
        let likeTapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.likeTapped))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
        
    }
    
    func replyTapped(img: AnyObject)
    {
        delegate?.reply?(tweetCell: self, replyTweet: tweet)
    }
    
    func likeTapped(img: AnyObject)
    {
        TwitterClient.sharedInstance.like(tweetId: tweet.id, success: likeSuccess, failure: likeFailed)
        
    }
    
    func likeSuccess() {
        favLabel.text = String(tweet.favCount + 1)
    }
    
    func likeFailed(error: Error) {
        print("like failed: \(error.localizedDescription)")
    }
    
    func retweetTapped(img: AnyObject)
    {
        TwitterClient.sharedInstance.retweet(tweetId: tweet.id, success: retweetSuccess, failure: retweetFailed)
        //POST https://api.twitter.com/1.1/statuses/retweet/243149503589400576.json
    }
    
    func retweetSuccess() {
        retweetLabel.text = String(tweet.retweetCount + 1)
        
    }
    
    func retweetFailed(error: Error) {
        print("retweet failed: \(error.localizedDescription)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
