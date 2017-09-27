//
//  User.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagline: String?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let urlString = dictionary["profile_image_url_https"] as? String,
            let url = URL(string: urlString) {
            profileURL = url
        }
        tagline = dictionary["description"] as? String
    }

}
