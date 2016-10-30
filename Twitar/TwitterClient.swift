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
    
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?) -> Void in
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(data: dictionaries)
                
                for tweet in tweets {
                    print("\(tweet.text)")
                }
                
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            
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
