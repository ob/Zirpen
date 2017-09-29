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
            likesLabel.text = String(format: "%d Likes", tweet.favouritesCount ?? 0)
            retweetsLabel.text = String(format: "%d Retweets", tweet.retweetCount ?? 0)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, y 'at' HH:MM"
            dateLabel.text = formatter.string(from: tweet.createdAt!)
            if let source = tweet.source {
                if let data = source.data(using: String.Encoding.utf16, allowLossyConversion: true),
                    let link = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    let txt = NSMutableAttributedString(string: "via ")
                    txt.append(link)
                    clientLabel.attributedText = txt
                } else {
                    clientLabel.text = String(format: "via %@", source)
                }
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
