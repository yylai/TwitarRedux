//
//  TimeLineViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var timeLineTableView: UITableView!
    @IBOutlet weak var timeSinceLabel: UILabel!
    
    
    var refresh: UIRefreshControl!
    
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
        
        TwitterClient.sharedInstance.homeTimeLine(success: successLoad, failure: failLoad)
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
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier!
        
        if id == "composeSegue" {
           //prep compose segue if any
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
