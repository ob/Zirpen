//
//  User.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class User: NSObject, Codable {

    static let userDidLogoutNotification = Notification.Name("UserDidLogout")
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagline: String?
    var followersCount: Int?
    var followingCount: Int?
    var profileBackgroundImageURL: URL?
    var profileBannerURL: URL?
    
    var prettyFollowersCount: NSAttributedString? {
        guard let followersCount = self.followersCount else {
            return nil
        }
        let retStr = NSMutableAttributedString(string: String(format: "%d", followersCount))
        retStr.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16.0)], range: NSMakeRange(0, retStr.length))
        retStr.append(NSAttributedString(string: " Followers"))
        return retStr
    }
    
    var prettyFollowingCount: NSAttributedString? {
        guard let followingCount = self.followingCount else {
            return nil
        }
        let retStr = NSMutableAttributedString(string: String(format: "%d", followingCount))
        retStr.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16.0)], range: NSMakeRange(0, retStr.length))
        retStr.append(NSAttributedString(string: " Following"))
        return retStr
    }
    
    var atScreenName: String? {
        get {
            if let sn = screenName {
                return String(format: "@%@", sn)
            }
            return nil
        }
    }

    init(dictionary: NSDictionary) {
        print(dictionary)
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let urlString = dictionary["profile_image_url_https"] as? String,
            let url = URL(string: urlString) {
            profileURL = url
        }
        tagline = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        if let urlString = dictionary["profile_background_image_url_https"] as? String,
            let url = URL(string: urlString) {
            profileBackgroundImageURL = url
        }
        if let urlString = dictionary["profile_banner_url"] as? String,
            let url = URL(string: urlString) {
            profileBannerURL = url
        }
//        "profile_background_color" = 000000;
//        "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme9/bg.gif";
//        "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme9/bg.gif";
//        "profile_background_tile" = 0;
//        "profile_banner_url" = "https://pbs.twimg.com/profile_banners/23419587/1443765929";
//        "profile_image_url" = "http://pbs.twimg.com/profile_images/788185962916425729/xnXY5DwC_normal.jpg";
//        "profile_image_url_https" = "https://pbs.twimg.com/profile_images/788185962916425729/xnXY5DwC_normal.jpg";
//        "profile_link_color" = 19CF86;
//        "profile_sidebar_border_color" = 000000;
//        "profile_sidebar_fill_color" = 000000;
//        "profile_text_color" = 000000;
//        "profile_use_background_image" = 0;

    }

    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "currentUser") {
                let user = try! PropertyListDecoder().decode(User.self, from: data)
                return user
            }
            return nil

        }
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let encodedData = try! PropertyListEncoder().encode(user)
                defaults.set(encodedData, forKey: "currentUser")
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }

}
