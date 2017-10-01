//
//  Tweet.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

enum Media {
    case photo(URL)
    case quoted(Tweet)
}

class Tweet: NSObject {
    
    var text: String?
    var truncated: Bool?
    var id: Int?
    var idStr: String?
    var inReplyToUserIdStr: String?
    var retweetCount: Int?
    var user: User?
    var retweetedTweet: Tweet?
    var favouritesCount: Int?
    var quotedTweet: Tweet?
    var createdAt: Date?
    var media: Media?
    var source: String?
    var retweeted: Bool
    var favorited: Bool
    var inReplyToIdStr: String?

    var prettyInterval: String? {
        get {
            guard let createdAt = createdAt else {
                return nil
            }
            var start = createdAt
            var end = Date()
            if start > end {
                let tmp = start
                start = end
                end = tmp
            }
            let seconds = DateInterval(start: start, end: end).duration
            let formatter = DateComponentsFormatter()
            var format = "%@"
            if seconds < 60 {
                formatter.allowedUnits = .second
                format = "%@s"
            } else if seconds < 3600 {
                formatter.allowedUnits = .minute
                format = "%@m"
            } else if seconds < 86_400 {
                formatter.allowedUnits = .hour
                format = "%@h"
            } else if seconds < 86_400 * 30 {
                formatter.allowedUnits = .day
            } else if seconds < 86_400 * 365 {
                formatter.allowedUnits = .month
            } else {
                formatter.allowedUnits = .year
            }
            return String(format: format, formatter.string(from: seconds)!)
        }
    }

    var prettySource: NSAttributedString? {
        get {
            guard let source = source else {
                return nil
            }
            // https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
            if let data = source.data(using: String.Encoding.utf16, allowLossyConversion: true),
                let link = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                let newLink = NSMutableAttributedString(attributedString: link)
                newLink.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0),
                                       NSAttributedStringKey.foregroundColor: UIColor.black,
                                       NSAttributedStringKey.strokeColor: UIColor.black], range: NSMakeRange(0, newLink.length))
                newLink.removeAttribute(NSAttributedStringKey.underlineStyle, range: NSMakeRange(0, newLink.length))
//                Swift crashes here.
//                newLink.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleNone, range: NSMakeRange(0, newLink.length))
                let prefix = NSMutableAttributedString(string: "via ")
                prefix.append(newLink)
                return prefix
            }
            return nil
        }
    }

    var prettyLiked: NSAttributedString? {
        get {
            guard let favouritesCount = self.favouritesCount else {
                return nil
            }
            let astr = NSMutableAttributedString(string: String(favouritesCount))
            let favs = NSAttributedString(string: " Likes")
            astr.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17.0)], range: NSMakeRange(0, astr.length))
            astr.append(favs)
            return astr
        }
    }

    var prettyRetweets: NSAttributedString? {
        get {
            guard let retweetCount = retweetCount else {
                return nil
            }
            let astr = NSMutableAttributedString(string: String(retweetCount))
            let retweets = NSAttributedString(string: " Retweets")
            astr.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17.0)], range: NSMakeRange(0, astr.length))
            astr.append(retweets)
            return astr
        }
    }

    init(user: User, text: String, inReplyTo: Tweet?) {
        self.text = text
        self.user = user
        self.inReplyToIdStr = inReplyTo?.idStr
        self.retweeted = false
        self.favorited = false
    }
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        //  "coordinates": null,
        truncated = dictionary["truncated"] as? Bool
        text = dictionary["text"] as? String
        if let created_at = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: created_at)
        }
        // "created_at": "Tue Aug 28 21:16:23 +0000 2012",
        idStr = dictionary["id_str"] as? String
        inReplyToUserIdStr = dictionary["in_reply_to_user_id_str"] as? String
        if let userDict = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDict)
        }
        if let retweetDict = dictionary["retweeted_status"] as? NSDictionary {
            retweetedTweet = Tweet.init(dictionary: retweetDict)
        }
        
        if let quotedDict = dictionary["quoted_tweet"] as? NSDictionary {
            quotedTweet = Tweet.init(dictionary: quotedDict)
        }
        
        if let entitiesDict = dictionary["entities"] as? NSDictionary,
            let mediaList = entitiesDict["media"] as? NSArray {
            for media in mediaList {
                guard let mediaDict = media as? NSDictionary else {
                    continue
                }
                guard let type = mediaDict["type"] as? String else {
                    continue
                }
                if type == "photo" {
                    if let urlString = mediaDict["media_url_https"] as? String,
                        let url = URL(string: urlString) {
                            self.media = Media.photo(url)
                    }
                }
            }
        }
        
        id = dictionary["id"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        favouritesCount = dictionary["favorite_count"] as? Int
        source = dictionary["source"] as? String

        retweeted = dictionary["retweeted"] as? Bool ?? false
        favorited = dictionary["favorited"] as? Bool ?? false
        inReplyToIdStr = dictionary["in_reply_to_status_id_str"] as? String
        // "geo": null,
        // "in_reply_to_user_id": null,
        // "place": null,

        //   "default_profile": false,
        //   "url": "http://bit.ly/oauth-dancer",
        //   "contributors_enabled": false,
        //   "utc_offset": null,
        //   "profile_image_url_https": "https://si0.twimg.com/profile_images/730275945/oauth-dancer_normal.jpg",
        //   "id": 119476949,
        //   "listed_count": 1,
        //   "profile_use_background_image": true,
        //   "profile_text_color": "333333",
        //   "followers_count": 28,
        //   "lang": "en",
        //   "protected": false,
        //   "geo_enabled": true,
        //   "notifications": false,
        //   "description": "",
        //   "profile_background_color": "C0DEED",
        //   "verified": false,
        //   "time_zone": null,
        //   "profile_background_image_url_https": "https://si0.twimg.com/profile_background_images/80151733/oauth-dance.png",
        //   "statuses_count": 166,
        //   "profile_background_image_url": "http://a0.twimg.com/profile_background_images/80151733/oauth-dance.png",
        //   "default_profile_image": false,
        //   "friends_count": 14,
        //   "following": false,
        //   "show_all_inline_media": false,
        //   "screen_name": "oauth_dancer"
        // },
        // "in_reply_to_screen_name": null,
        // "in_reply_to_status_id": null
    }

    class func fromDictionaryArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = [Tweet]()
        for dictionary in dictionaryArray {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
