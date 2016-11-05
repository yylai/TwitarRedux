//
//  TwitterClient.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let userDidLogoutNotification = "UserDidLogout"
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "nOcwFLvEQzcJABSGtOXP2sWmN", consumerSecret: "Uosre0bBQMfV3q9LUJTPMhAmZ7GQ5FPf6g6JpS82aFEWb5aZu3")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            print("request token: \(requestToken!.token)")
            
            let token = requestToken!.token
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")!
            
            UIApplication.shared.open(url)
            
        }, failure: {(error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
            })
        
    }
    
    func like(tweetId id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String : AnyObject] = ["id": id as AnyObject]
        //https://api.twitter.com/1.1/favorites/create.json?id=243138128959913986
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (session: URLSessionDataTask, sender: Any?) in
            success()
            
        }, failure: { (session: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func retweet(tweetId id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        //POST https://api.twitter.com/1.1/statuses/retweet/243149503589400576.json
        let url = "1.1/statuses/retweet/\(id).json"
        
        post(url, parameters: nil, progress: nil, success: { (session: URLSessionDataTask, sender: Any?) in
            success()
            
        }, failure: { (session: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func reply(tweet: String, id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        let parameters: [String : AnyObject] = ["status": tweet as AnyObject, "in_reply_to_status_id": id as AnyObject]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (session: URLSessionDataTask, sender: Any?) in
            success()
            
        }, failure: { (session: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    
    func postTweet(tweet: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        let parameters: [String : AnyObject] = ["status": tweet as AnyObject]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (session: URLSessionDataTask, sender: Any?) in
            success()
            
        }, failure: { (session: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: Error?) in
                print("account retrieval error")
                self.loginFailure?(error!)
            })
            
        }, failure: {(error: Error?) -> Void in
            self.loginFailure?(error!)
        })
        
    }
    
    
    func userTimeLine(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String : AnyObject] = ["screen_name": screenName as AnyObject]
        
        print("user time line for id \(screenName)")
        
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?) -> Void in
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(data: dictionaries)
                success(tweets)
                
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?) -> Void in
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(data: dictionaries)
                success(tweets)
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func showUser(screenName: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String : AnyObject] = ["screen_name": screenName as AnyObject]
        
        get("1.1/users/show.json", parameters: parameters, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?) -> Void in
                
                let userDict = response as! NSDictionary
                let user = User(data: userDict)
                print("name: \(user.name!)")
                
                success(user)
                
                
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?) -> Void in
                
                let userDict = response as! NSDictionary
                let user = User(data: userDict)
                print("name: \(user.name!)")
                
                success(user)
                
                
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(TwitterClient.userDidLogoutNotification), object: nil)
    }
    
}
