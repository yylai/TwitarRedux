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
    var retweetCount: Int = 0
    var favCount: Int = 0
    
    init(data: NSDictionary) {
        text = data["text"] as? String
        
        
        retweetCount = data["retweet_count"] as? Int ?? 0
        favCount = data["favorite_count"] as? Int ?? 0
        
        let timeStampStr = data["created_at"] as? String
        
        if let ts = timeStampStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeStamp = formatter.date(from: ts)
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
