//
//  TimeLineViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, ComposeViewControllerDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var timeLineTableView: UITableView!
    
    var refresh: UIRefreshControl!
    var originalLeftMargin: CGFloat!
    
    var isMentionsTimeline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialize a UIRefreshControl
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: .valueChanged)
        timeLineTableView.insertSubview(refresh, at: 0)
        
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        timeLineTableView.rowHeight = UITableViewAutomaticDimension
        timeLineTableView.estimatedRowHeight = 120
        
        if isMentionsTimeline {
            self.navigationItem.title = "Mentions"
            TwitterClient.sharedInstance.mentions(success: successLoad, failure: failLoad)
        } else {
            self.navigationItem.title = "Twitter"
            TwitterClient.sharedInstance.homeTimeLine(success: successLoad, failure: failLoad)
            
        }
        
        
    }
    
    func successLoad(tweets: [Tweet]) {
        MBProgressHUD.hide(for: self.view, animated: true)
        refresh.endRefreshing()
        self.tweets = tweets
        self.timeLineTableView.reloadData()
    }
    
    func failLoad(error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
        print("Error loading timeline: \(error.localizedDescription)")
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeLine(success: successLoad, failure: failLoad)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance.logout()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        
        if id == "composeSegue" {
           //prep compose segue if any
            //ComposeViewControllerDelegate
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.delegate = self
        }
        
        if id == "detailsSegue" {
            print("start details segue")
            let cell = sender as! TweetCell
            let indexPath = timeLineTableView.indexPath(for: cell)!
            let tweet = tweets[indexPath.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.tweet = tweet
        }
        
        
    }
    
    func reply(tweetCell: TweetCell, replyTweet: Tweet) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        vc.isReply = true
        vc.replyTweet = replyTweet
        
        //in_reply_to_status_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func profile(tweetCell: TweetCell, profileTweet: Tweet) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.profileTweet = profileTweet
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func posted() {
        TwitterClient.sharedInstance.homeTimeLine(success: successLoad, failure: failLoad)
    }
    
}
