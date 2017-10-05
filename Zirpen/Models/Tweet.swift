//
//  Tweet.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

enum MediaType {
    case photo
}

struct Media {
    let displayURL: String
    let expandedURL: URL
    let indices: (Int, Int)
    let mediaURL: URL
    let mediaURLHTTPS: URL
    let type: MediaType
    let url: URL
}

struct EntityURL {
    let url: URL
    let displayURL: String
    let expandedURL: URL
    let indices: (Int, Int)
}

struct UserMention {
    let id: Int
    let idStr: String
    let name: String
    let screenName: String
    let indices: (Int, Int)
}

struct HashTag {
    let text: String
    let indices: (Int, Int)
}

enum Entity {
    case urls([EntityURL])
    case userMentions([UserMention])
    case hashtag([HashTag])
    case media([Media])
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
    var urls: [String]?
    var entities: [Entity]?

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

    var _prettyText: NSAttributedString?
    var prettyText: NSAttributedString? {
        get {
            if _prettyText != nil {
                return _prettyText
            }
            guard let txt = self.text else {
                return nil
            }
            guard let entities = self.entities else {
                return NSAttributedString(string: txt)
            }
            let retString = NSMutableAttributedString(string: "")
            var indices = [((Int, Int), NSAttributedString)]()
            for entity in entities {
                switch entity {
                case .hashtag(let hashtags):
                    for hashtag in hashtags {
                        let txt = NSMutableAttributedString(string: "#")
                        txt.append(NSMutableAttributedString(string: hashtag.text))
                        txt.addAttributes([NSAttributedStringKey.strokeColor : UIColor.blue,
                                                 NSAttributedStringKey.foregroundColor: UIColor.blue,
                                                 NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0)], range: NSMakeRange(0, txt.length))
                        indices.append((hashtag.indices, txt))
                    }
                case .media(let mediaArray):
                    for media in mediaArray {
                        switch media.type {
                        case .photo:
                            indices.append((media.indices, NSAttributedString(string: "")))
                        }
                    }
                case .urls(let allURLs):
                    for url in allURLs {
                        // remove quoted tweets since we'll display them inline
                        if url.displayURL.starts(with: "twitter.com") {
                            indices.append((url.indices, NSAttributedString(string: "")))
                            continue
                        }
                        let txt = NSMutableAttributedString(string: url.displayURL)
                        txt.addAttributes([NSAttributedStringKey.strokeColor: UIColor.blue,
                                                NSAttributedStringKey.foregroundColor: UIColor.blue,
                                                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0)], range: NSMakeRange(0, txt.length))
                        indices.append((url.indices, txt))
                    }
                case .userMentions(let userMentions):
                    for um in userMentions {
                        let txt = NSMutableAttributedString(string: "@")
                        txt.append(NSMutableAttributedString(string: um.screenName))
                        txt.addAttributes([NSAttributedStringKey.strokeColor : UIColor.blue,
                                                 NSAttributedStringKey.foregroundColor: UIColor.blue,
                                                 NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0)], range: NSMakeRange(0, txt.length))
                        indices.append((um.indices, txt))
                    }
                }
            }
            var startIndex = String.Index.init(encodedOffset: 0)
            for j in indices.sorted(by: { $0.0.0 < $1.0.0 }) {
                let jIndex = String.Index.init(encodedOffset: j.0.0)
                if startIndex < jIndex {
                    retString.append(NSAttributedString(string: String(txt[startIndex..<jIndex])))
                }
                retString.append(j.1)
                startIndex = String.Index.init(encodedOffset: j.0.1)
            }
            if startIndex < txt.endIndex {
                retString.append(NSAttributedString(string: String(txt[startIndex..<txt.endIndex])))
            }
            _prettyText = retString
            return retString
        }
    }
    
    var imageURL: URL? {
        get {
            guard let entities = self.entities else {
                return nil
            }
            for entity in entities {
                switch entity {
                case .media(let mediaArray):
                    for media in mediaArray {
                        switch media.type {
                        case .photo:
                            return media.mediaURLHTTPS
                        }
                    }
                default:
                    continue
                }
            }
            return nil
        }
    }

    init(user: User, text: String, inReplyTo: Tweet?) {
        self.text = text
        self.user = user
        self.inReplyToIdStr = inReplyTo?.idStr
        self.retweeted = false
        self.favorited = false
    }
    
    fileprivate class func parseEntities(_ dictionary: NSDictionary) -> [Entity]? {
        var entities = [Entity]()
        if let mediaList = dictionary["media"] as? NSArray {
            var allMedia = [Media]()
            for media in mediaList {
                guard let mediaDict = media as? NSDictionary else {
                    continue
                }
                guard let type = mediaDict["type"] as? String else {
                    continue
                }
                if type == "photo" {
                    let displayURL = mediaDict["display_url"] as! String
                    var url = mediaDict["expanded_url"] as! String
                    let expandedURL = URL(string: url)!
                    let indexArray = mediaDict["indices"] as! NSArray
                    let index1 = indexArray[0] as! Int
                    let index2 = indexArray[1] as! Int
                    let indices = (index1, index2)
                    url = mediaDict["media_url"] as! String
                    let mediaURL = URL(string: url)!
                    url = mediaDict["media_url_https"] as! String
                    let mediaURLHTTPS = URL(string: url)!
                    url = mediaDict["url"] as! String
                    let url1 = URL(string: url)!
                    let media = Media(displayURL: displayURL, expandedURL: expandedURL, indices: indices, mediaURL: mediaURL, mediaURLHTTPS: mediaURLHTTPS, type: .photo, url: url1)
                    allMedia.append(media)
                }
            }
            entities.append(Entity.media(allMedia))
        }
        if let hashtagList = dictionary["hashtags"] as? NSArray {
            var hashtags = [HashTag]()
            for hashtag in hashtagList {
                guard let hashtagDict = hashtag as? NSDictionary else {
                    continue
                }
                let txt = hashtagDict["text"] as! String
                let indexArray = hashtagDict["indices"] as! NSArray
                let idx1 = indexArray[0] as! Int
                let idx2 = indexArray[1] as! Int
                let hashtag = HashTag(text: txt, indices: (idx1, idx2))
                hashtags.append(hashtag)
            }
            entities.append(Entity.hashtag(hashtags))
        }
        if let urlList = dictionary["urls"] as? NSArray {
            var urls = [EntityURL]()
            for url in urlList {
                guard let urlDict = url as? NSDictionary else {
                    continue
                }
                let urlString = urlDict["url"] as! String
                let urlURL = URL(string: urlString)!
                let displayURL = urlDict["display_url"] as! String
                let expandedURLString = urlDict["expanded_url"] as! String
                let expandedURL = URL(string: expandedURLString)!
                let indexArray = urlDict["indices"] as! NSArray
                let idx1 = indexArray[0] as! Int
                let idx2 = indexArray[1] as! Int
                let url = EntityURL(url: urlURL, displayURL: displayURL, expandedURL: expandedURL, indices: (idx1, idx2))
                urls.append(url)
            }
            entities.append(Entity.urls(urls))
        }
        if let userMentionsArray = dictionary["user_mentions"] as? NSArray {
            var userMentions = [UserMention]()
            for userMention in userMentionsArray {
                guard let userMentionDict = userMention as? NSDictionary else {
                    continue
                }
                let name = userMentionDict["name"] as! String
                let screenName = userMentionDict["screen_name"] as! String
                let id = userMentionDict["id"] as! Int
                let idStr = userMentionDict["id_str"] as! String
                let indexArray = userMentionDict["indices"] as! NSArray
                let idx1 = indexArray[0] as! Int
                let idx2 = indexArray[1] as! Int
                let userMention = UserMention(id: id, idStr: idStr, name: name, screenName: screenName, indices: (idx1, idx2))
                userMentions.append(userMention)
            }
            entities.append(Entity.userMentions(userMentions))
        }
        return entities
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
        
        if let quotedDict = dictionary["quoted_status"] as? NSDictionary {
            quotedTweet = Tweet.init(dictionary: quotedDict)
        }
        
        if let entitiesDict = dictionary["entities"] as? NSDictionary {
            entities = Tweet.parseEntities(entitiesDict)
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
