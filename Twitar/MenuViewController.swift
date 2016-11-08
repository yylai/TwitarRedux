//
//  MenuViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 11/6/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    
    var viewControllers: [UIViewController] = []
    var menuDescription: [String] = ["My Profile", "My Timeline", "My Mentions"]
    
    var hamburgerViewController: HamburgerViewController!
    var profileViewController: ProfileViewController!
    var timelineViewController: UIViewController!
    var mentionsViewController: UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        let mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let mentionsVC = mentionsNavigationController.topViewController as! TimeLineViewController
        mentionsVC.isMentionsTimeline = true
        
        mentionsViewController = mentionsNavigationController
        
        let name = User.currentUser!.name!
        let screenName = User.currentUser!.screenName!
        let url = User.currentUser!.profileUrl!.absoluteString
        
        userImageView.setImageWith(User.currentUser!.profileUrl!)
        userNameLabel.text = name
        
        let i = screenName.index(after: screenName.startIndex)
        
        let r = i..<screenName.endIndex
        
        let userDict: NSDictionary = [
            "name": name,
            "screen_name": screenName.substring(with: r),
            "profile_image_url_https": url
        ]
        
        let tweetData: NSDictionary = [
            "id_str": "fake",
            "user" : userDict
        ]
        
        profileViewController.profileTweet = Tweet(data: tweetData)
        
        viewControllers.append(profileViewController)
        viewControllers.append(timelineViewController)
        viewControllers.append(mentionsViewController)
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 120
        
        hamburgerViewController.cvController = viewControllers[1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.MenuNameLabel.text = menuDescription[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.cvController = viewControllers[indexPath.row]
    }

}
