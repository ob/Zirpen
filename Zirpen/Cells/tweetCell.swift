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
    @IBOutlet weak var favoritedImageView: UIImageView!
    
    var detail = false
    var photoURL: URL?
    
    func displayTweet(_ tweet: Tweet) {
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        screenNameLabel.text = tweet.user?.atScreenName
        dateIntervalLabel.text = tweet.prettyInterval
        profileImageView.image = #imageLiteral(resourceName: "person")
        if let url = tweet.user?.profileURL {
            profileImageView.setImageWith(url)
        }
        if tweet.favorited && !detail {
            favoritedImageView.image = #imageLiteral(resourceName: "favorite-full-16")
            favoritedImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            favoritedImageView.isHidden = false
        } else {
            favoritedImageView.isHidden = true
        }
        if let media = tweet.media {
            switch media {
            case .photo(let url):
                photoURL = url
                if !detail {
                    displayPhotoEmbedded(url: url)
                }
            }
        } else {
            mediaView.isHidden = true
            mediaView.subviews.forEach {$0.removeFromSuperview()}
        }
    }
    
    func displayPhotoEmbedded(url: URL) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height))
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.setImageWith(url)
        mediaView.addSubview(imgView)
        mediaView.isHidden = false
    }
    
    func displayRetweeter(_ user: User?) {
        extraStatusView.isHidden = false
        retweetImage.image = #imageLiteral(resourceName: "person")
        if let url = user?.profileURL {
            retweetProfileImage.setImageWith(url)
        }
        retweetNameLabel.text = user?.name
        if tweet.retweeted  && user?.screenName != User.currentUser?.screenName {
            retweetNameLabel.text = retweetNameLabel.text! + " and You"
        }
        retweetImage.image = #imageLiteral(resourceName: "retweet-1-16")
    }
    
    func configureDetail() {
        dateIntervalLabel.isHidden = true
        favoritedImageView.isHidden = true
        textLabel?.font.withSize(22.0)
    }
    
    var tweet: Tweet! {
        didSet {
            if tweet.retweetedTweet != nil {
                displayTweet(tweet.retweetedTweet!)
                displayRetweeter(tweet.user)
            } else  if tweet.retweeted {
                displayTweet(tweet)
                displayRetweeter(User.currentUser)
            } else {
                extraStatusView.isHidden = true
                displayTweet(tweet)
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
