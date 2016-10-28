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
    
    init(data: NSDictionary) {
        name = data["name"] as? String
        screenName = data["screen_name"] as? String
        let profileURLStr = data["profile_image_url_https"] as? String
        
        if let url = profileURLStr {
            profileUrl = URL(string: url)
        }
        
        tagLine = data["description"] as? String
    }
    
}
