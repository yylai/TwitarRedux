//
//  TimeLineViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {

    var tweets: [Tweet]!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            for tweet in self.tweets {
                print(tweet.text!)
            }
        }, failure: {(error: Error) in
            print("errR")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance.logout()
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
