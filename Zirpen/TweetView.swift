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

    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet? {
        didSet {
            retweetedByStackView.isHidden = true
            if tweet?.retweetedTweet != nil {
                displayTweet(tweet!.retweetedTweet!)
                displayRetweeter(tweet!.user!, andYou: tweet!.retweeted)
            } else {
                displayTweet(tweet!)
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
        
        favoriteButton.setImage(#imageLiteral(resourceName: "favorite-4-16"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "favorite-full-16"), for: .selected)
        favoriteButton.isSelected = false

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
        favoriteButton.isSelected = tweet.favorited
    }
    
    fileprivate func displayQuotedTweet(_ tweet: Tweet) {
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

    fileprivate func displayRetweeter(_ rtuser: User?, andYou: Bool) {
        var user: User? = rtuser
        var retweetedByMe = andYou
        if user == nil {
            user = User.currentUser
            retweetedByMe = false
        }
        guard user != nil || retweetedByMe else {
            return
        }
        if let url = user!.profileURL {
            retweetProfileImage.setImageWith(url)
        }
        var retweetString = "Retweeted by "
        if let name = user!.name {
            retweetString.append(name)
        }
        if retweetedByMe {
            retweetString.append("and You")
        }
        retweeterNameLabel.text = retweetString
        retweetedByStackView.isHidden = false
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        var tweet: Tweet = self.tweet!
        if tweet.retweetedTweet != nil {
            tweet = tweet.retweetedTweet!
        }
        if tweet.favorited {
            TwitterClient.shared.unfavourite(tweet: tweet, completion: { (tweet, error) in
                if error == nil {
                    self.favoriteButton.isSelected = false
                    self.tweet?.favorited = false
                } else {
                    print("FAILED: \(error!.localizedDescription)")
                }
            })
        } else {
            TwitterClient.shared.favourite(tweet: tweet, completion: { (tweet, error) in
                if error == nil {
                    self.favoriteButton.isSelected = true
                    self.tweet?.favorited = true
                } else {
                    print("FAILED: \(error!.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func retweetButtonTapped(_ sender: Any) {
        var tweet: Tweet = self.tweet!
        var retweetUser: User?
        if tweet.retweetedTweet != nil {
            tweet = tweet.retweetedTweet!
            retweetUser = tweet.user
        }
        if tweet.retweeted {
            TwitterClient.shared.unretweet(tweet: tweet, completion: { (tweet, error) in
                if error == nil {
                    self.tweet?.retweeted = false
                    self.displayRetweeter(retweetUser, andYou: false)
                } else {
                    print("FAILED: \(error!.localizedDescription)")
                }
            })
        } else {
            TwitterClient.shared.retweet(tweet: tweet, completion: { (tweet, error) in
                if error == nil {
                    self.tweet?.retweeted = true
                    self.displayRetweeter(retweetUser, andYou: true)
                } else {
                    print("FAILED: \(error!.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
    }
}
