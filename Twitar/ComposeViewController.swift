//
//  ComposeViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/30/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var charRemainingLabel: UILabel!
    
    let MAX_CHAR: Int = 140
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let user = User.currentUser!
        
        profileImageView.setImageWith(user.profileUrl!)
        nameLabel.text = user.name!
        screenNameLabel.text = user.screenName!
        
        charRemainingLabel.text = String(MAX_CHAR)
        
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= MAX_CHAR;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let remaining = MAX_CHAR - textView.text.characters.count
        charRemainingLabel.text = String(remaining)
        
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
       self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func onTweetButton(_ sender: Any) {
        TwitterClient.sharedInstance.postTweet(tweet: tweetTextView.text, success: postSuccess, failure: postFail)
        
    }
    
    func postSuccess() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func postFail(error: Error) {
        print("post failure: \(error.localizedDescription)")
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
