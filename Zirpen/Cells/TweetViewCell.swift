//
//  TweetViewCell.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/1/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    @IBOutlet weak var tweetView: TweetView!

    var tweet: Tweet! {
        didSet {
            tweetView.tweet = tweet
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
