//
//  tweetCell.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/27/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class tweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetProfileImage: UIImageView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var extraStatusView: UIStackView!
    
    var tweet: Tweet! {
        didSet {
            var t:Tweet = tweet!
            if tweet.retweetedTweet != nil {
                t = tweet.retweetedTweet!
                extraStatusView.isHidden = false
                if let url = tweet.user?.profileURL {
                    retweetProfileImage.setImageWith(url)
                }
                dateIntervalLabel.text = tweet.prettyInterval
                retweetNameLabel.text = tweet.user?.name
                retweetImage.image = #imageLiteral(resourceName: "retweet-1-16")
            } else {
                extraStatusView.isHidden = true
            }
            nameLabel.text = t.user?.name
            tweetTextLabel.text = t.text
            screenNameLabel.text = t.user?.atScreenName
            dateIntervalLabel.text = t.prettyInterval
            if let url = t.user?.profileURL {
                profileImageView.setImageWith(url)
            }
            if let media = t.media {
                switch media {
                case .photo(let url):
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height))
                    imgView.clipsToBounds = true
                    imgView.contentMode = .scaleAspectFit
                    imgView.setImageWith(url)
                    mediaView.addSubview(imgView)
                    mediaView.isHidden = false
                }
            } else {
                mediaView.isHidden = true
                mediaView.subviews.forEach {$0.removeFromSuperview()}
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        retweetProfileImage.layer.cornerRadius = retweetProfileImage.frame.size.width / 2
        retweetProfileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
