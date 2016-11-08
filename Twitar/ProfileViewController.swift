//
//  ProfileViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 11/5/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileNavItem: UINavigationItem!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var numOfTweetsLabel: UILabel!
    @IBOutlet weak var numOfFollowingLabel: UILabel!
    @IBOutlet weak var numOfFollowers: UILabel!

    var tweets: [Tweet]!
    var profileTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.setImageWith(profileTweet.profileUrl!)
        nameLabel.text = profileTweet.name!
        screenNameLabel.text = profileTweet.screenName!
        
        
        
        profileNavItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.goBack))
        
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.showUser(screenName: profileTweet.screenNameNoSymbol!, success: successLoadUser, failure: errorLoadingUser)
        
        TwitterClient.sharedInstance.userTimeLine(screenName: profileTweet.screenNameNoSymbol!, success: successLoad, failure: errorLoading)
    }
    
    func successLoadUser(user: User) {
        numOfTweetsLabel.text = String(user.numOfTweets!)
        numOfFollowingLabel.text = String(user.numOfFollowing!)
        numOfFollowers.text = String(user.numOfFollowers!)
        if let bgURL = user.profileBgUrl {
            backgroundImage.setImageWith(bgURL)
        }
        
    }
    
    func successLoad(tweets: [Tweet]) {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.tweets = tweets
        self.profileTableView.reloadData()
    }
    
    func errorLoadingUser(error: Error) {
        print("user load error: \(error.localizedDescription)")
    }
    
    func errorLoading(error: Error) {
        print("time line error: \(error.localizedDescription)")
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
        
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
