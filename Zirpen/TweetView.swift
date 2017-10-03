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
        
        favoritedImageView.tintColor = UIColor.red
    }
    
    fileprivate func displayTweet(_ tweet: Tweet) {
        if let url = tweet.user?.profileURL {
            avatarImageView.setImageWith(url)
        }
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = String(format: "@%@", tweet.user!.screenName!)
        if let attrtext = tweet.prettyText {
            tweetTextLabel.attributedText = attrtext
        } else {
            tweetTextLabel.text = tweet.text
        }
        howLongAgoLabel.text = tweet.prettyInterval
        if tweet.favorited {
            favoritedImageView.isHidden = false
        } else {
            favoritedImageView.isHidden = true
        }
        mediaView.subviews.forEach { $0.removeFromSuperview() }
        mediaView.isHidden = true
        for entity in tweet.entities ?? [] {
            switch entity {
            case .media(let mediaArray):
                displayMedia(media: mediaArray.first)
            default:
                continue
            }
        }
        if tweet.quotedTweet != nil {
            displayQuotedTweet(tweet.quotedTweet!)
        }
    }
    
    fileprivate func displayQuotedTweet(_ tweet: Tweet) {
        print("DISPLAYING QUOTED TWEET: \(tweet.text!)")
        let quotedTweetView = MiniTweetView(frame: CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height))
        quotedTweetView.tweet = tweet
        mediaView.addSubview(quotedTweetView)
        mediaView.isHidden = false
    }
    
    fileprivate func displayMedia(media: Media?) {
        guard let media = media else {
            return
        }
        mediaView.isHidden = false
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height))
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.isHidden = false
        imgView.setImageWith(media.mediaURLHTTPS)
        mediaView.addSubview(imgView)
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
