//
//  Tweet.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import Foundation


class Tweet: NSObject {
    
    var text: String?
    var timeStamp: Date?
    var timeSinceNow: String? //as a property
    var retweetCount: Int = 0
    var favCount: Int = 0
    var profileUrl: URL?
    var name: String?
    var screenName: String?
    var id: String
    
    
    init(data: NSDictionary) {
        text = data["text"] as? String
        retweetCount = data["retweet_count"] as? Int ?? 0
        favCount = data["favorite_count"] as? Int ?? 0
        id = data["id_str"] as! String
        
        let timeStampStr = data["created_at"] as? String
        
        if let ts = timeStampStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: ts)
        }
        
        let user = data["user"] as? NSDictionary
        name = user?["name"] as? String
        if let sn = user?["screen_name"] as? String {
            screenName = "@\(sn)"
        }
        
        if let url = user?["profile_image_url_https"] as? String {
            print("profile url: \(url)")
            profileUrl = URL(string: url)
        }
        
        
    }
    
    class func tweetsWithArray(data: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in data {
            let tweet = Tweet(data: dictionary)
            tweets.append(tweet)
        }
        
        
        return tweets
    }
    
}
