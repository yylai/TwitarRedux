//
//  ViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.sharedInstance.login(success: {
            print("i have logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: {(error: Error) -> () in
            print("login error: \(error.localizedDescription)")
        })
        
    }

}

