//
//  Tweet.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?

    init(dictionary: NSDictionary) {
//        print(dictionary)
        text = dictionary["text"] as? String
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
