//
//  DetailsViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/30/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileImageView.setImageWith(tweet.profileUrl!)
        nameLabel.text = tweet.name!
        screenNameLabel.text = tweet.screenName!
        tweetLabel.text = tweet.text!
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateTimeLabel.text = formatter.string(from: tweet.timeStamp!)
        
        
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        vc.isReply = true
        vc.replyTweet = tweet
        
        //in_reply_to_status_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func likeTapped(img: AnyObject)
    {
        print("like")
        TwitterClient.sharedInstance.like(tweetId: tweet.id, success: likeSuccess, failure: likeFailed)
        
    }
    
    func likeSuccess() {
        print("like success")
    }
    
    func likeFailed(error: Error) {
        print("like failed: \(error.localizedDescription)")
    }
    
    func retweetTapped(img: AnyObject)
    {
        print("retweet")
        TwitterClient.sharedInstance.retweet(tweetId: tweet.id, success: retweetSuccess, failure: retweetFailed)
        //POST https://api.twitter.com/1.1/statuses/retweet/243149503589400576.json
    }
    
    func retweetSuccess() {
        print("retweeted")
    }
    
    func retweetFailed(error: Error) {
        print("retweet failed: \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
