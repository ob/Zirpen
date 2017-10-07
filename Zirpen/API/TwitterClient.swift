//
//  TwitterClient.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/27/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

enum Timeline {
    case Home, Mentions
}

class TwitterClient: BDBOAuth1SessionManager {

    static let shared = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!,
                                                consumerKey: "ZuByPvIFnaqRCHS4SgRgIYZ8E",
                                                consumerSecret: "cveQTM3xvOtbatFgASRKJZS3AoXjPlWtKMHcfeKnUNmMKSOSXR")!

    var loginCompletion: ((Bool, Error?) -> Void)?

    func login(completion: @escaping ((Bool, Error?) -> Void)) {
        deauthorize()
        loginCompletion = completion
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "zirpen://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken.token)!
            UIApplication.shared.open(url, options: [String:Any](), completionHandler: nil)
        }, failure: { (error: Error?) in
            self.loginCompletion?(false, error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }

    func handleURL(url: URL) -> Bool {
        if (url.query?.contains("denied=") ?? false) {
            self.loginCompletion!(false, Failed(0, "Authorization denied."))
            return true
        }
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            self.authorizedUser(completion: { (user, error) in
                if let user = user {
                    User.currentUser = user
                    self.loginCompletion?(true, nil)
                } else {
                    self.loginCompletion?(false, error)
                }
            })
        }, failure: { (error) in
            self.loginCompletion?(false, error)
        })
        return true
    }

    func timeline(timeline: Timeline, fromId: Int?, completion: @escaping (([Tweet]?, Error?) -> Void)) {
        var parameters = [String:Any]()
        if let id = fromId {
            parameters["max_id"] = id
        }
        var endpoint: String
        switch timeline {
        case .Home:
            endpoint = "1.1/statuses/home_timeline.json"
        case .Mentions:
            endpoint = "1.1/statuses/mentions_timeline.json"
        }
        get(endpoint, parameters: parameters, progress: nil, success: { (task, response) in
            if let responseDictionaryArray = response as? [NSDictionary] {
                let tweets = Tweet.fromDictionaryArray(dictionaryArray: responseDictionaryArray)
                completion(tweets, nil)
            } else {
                completion(nil, self.Failed(0, "Internal error"))
            }
        }, failure: { (task, error) in
            completion(nil, error)
        })

    }

    func authorizedUser(completion: @escaping ((User?, Error?) -> Void)) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            if let responseDictionary = response as? NSDictionary {
                let user = User(dictionary: responseDictionary)
                completion(user, nil)
            } else {
                completion(nil, self.Failed(0, "Invalid response from server"))
            }
        }, failure: { (task, error) in
            completion(nil, error)
        })
    }
    
    fileprivate func action(endpoint: String, parameters: [String:Any]?, tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        post(endpoint, parameters: parameters, progress: nil, success: { (task, response) in
            completion(tweet, nil)
        }) { (task, error) in
            print("ACTION FAILED: \(error.localizedDescription) - \(task!)")
            completion(nil, error)
        }
    }

    func retweet(tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        let endpoint = String(format: "1.1/statuses/retweet/%@.json", tweet.idStr!)
        action(endpoint: endpoint, parameters:nil, tweet: tweet, completion: completion)
    }
    
    func unretweet(tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        let endpoint = String(format: "1.1/statuses/unretweet/%@.json", tweet.idStr!)
        action(endpoint: endpoint, parameters:nil, tweet: tweet, completion: completion)
    }
    
    func favourite(tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        let endpoint = String(format: "1.1/favorites/create.json?id=%@", tweet.idStr!)
        var parameters = [String:Any]()
        parameters["id"] = tweet.idStr!
        action(endpoint: endpoint, parameters: nil, tweet: tweet, completion: completion)
    }
    
    func unfavourite(tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        let endpoint = String(format: "1.1/favorites/destroy.json?id=%@", tweet.idStr!)
        action(endpoint: endpoint, parameters: nil, tweet: tweet, completion: completion)
    }

    func tweet(tweet: Tweet, completion: @escaping ((Tweet?, Error?) -> Void)) {
        var endpoint = "1.1/statuses/update.json?"
        guard let quotedStatus = tweet.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil, self.Failed(0, "Could not encode status"))
            return
        }
        endpoint += String(format: "status=%@", quotedStatus)
        if let replyto = tweet.inReplyToIdStr {
            endpoint += String(format: "&in_reply_to_status_id=%@", replyto)
        }
        action(endpoint: endpoint, parameters: nil, tweet: tweet, completion: completion)
    }

    func Failed(_ code: Int, _ message: String) -> NSError {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
