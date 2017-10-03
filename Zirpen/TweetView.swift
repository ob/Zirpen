//
//  TweetView.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/1/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

// https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
class TweetView: UIView {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var howLongAgoLabel: UILabel!
    @IBOutlet weak var favoritedImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var retweetProfileImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var retweeterNameLabel: UILabel!
    @IBOutlet weak var retweetedByStackView: UIStackView!
    @IBOutlet weak var buttonsView: UIStackView!

    var tweet: Tweet? {
        didSet {
            if tweet?.retweetedTweet != nil {
                displayTweet(tweet!.retweetedTweet!)
                displayRetweeter(tweet!.user!, andYou: tweet!.retweeted)
                retweetedByStackView.isHidden = false
            } else {
                displayTweet(tweet!)
                retweetedByStackView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TweetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        retweetProfileImage.layer.cornerRadius = retweetProfileImage.frame.size.width / 2
        retweetProfileImage.clipsToBounds = true

        tweetTextLabel.preferredMaxLayoutWidth = 200.0
    }
    
    fileprivate func displayTweet(_ tweet: Tweet) {
        if let url = tweet.user?.profileURL {
            avatarImageView.setImageWith(url)
        }
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = String(format: "@%@", tweet.user!.screenName!)
        tweetTextLabel.text = tweet.text
        howLongAgoLabel.text = tweet.prettyInterval
        if tweet.favorited {
            favoritedImageView.isHidden = false
        } else {
            favoritedImageView.isHidden = true
        }
    }

    fileprivate func displayRetweeter(_ user: User, andYou: Bool) {
        if let url = user.profileURL {
            retweetProfileImage.setImageWith(url)
        }
        var retweetString = "Retweeted by "
        if let name = user.name {
            retweetString.append(name)
        }
        if andYou {
            retweetString.append("and You")
        }
        retweeterNameLabel.text = retweetString
    }
}
