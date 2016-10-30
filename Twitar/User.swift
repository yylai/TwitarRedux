//
//  User.swift
//  Twitar
//
//  Created by YINYEE LAI on 10/27/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import Foundation


class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    var data: NSDictionary?
    
    init(data: NSDictionary) {
        name = data["name"] as? String
        screenName = data["screen_name"] as? String
        let profileURLStr = data["profile_image_url_https"] as? String
        
        if let url = profileURLStr {
            profileUrl = URL(string: url)
        }
        
        tagLine = data["description"] as? String
        
        self.data = data
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUser") as? Data
                
                if let u = userData {
                    let userDictionary = try! JSONSerialization.jsonObject(with: u, options: []) as! NSDictionary
                    _currentUser = User(data: userDictionary)
                }

            }
            
            
            return _currentUser
            
        }
        set(user) {
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let u = user {
                let data = try! JSONSerialization.data(withJSONObject: u.data!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            
            defaults.synchronize()
        
        }
    }
    
}
