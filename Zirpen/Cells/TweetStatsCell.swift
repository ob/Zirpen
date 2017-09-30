//
//  TweetStatsCell.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/29/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class TweetStatsCell: UITableViewCell {

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            if tweet.prettyLiked != nil {
                likesLabel.attributedText = tweet.prettyLiked!
            } else {
                likesLabel.text = String(format: "%d Likes", tweet.favouritesCount ?? 0)
            }
            if tweet.prettyRetweets != nil {
                retweetsLabel.attributedText = tweet.prettyRetweets!
            } else {
                retweetsLabel.text = String(format: "%d Retweets", tweet.retweetCount ?? 0)
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, y 'at' HH:MM"
            dateLabel.text = formatter.string(from: tweet.createdAt!)
            if tweet.prettySource != nil {
                clientLabel.attributedText = tweet.prettySource!
            } else if tweet.source != nil {
                clientLabel.text = "via " + tweet.source!
            } else {
                clientLabel.text = "via Unknown"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
