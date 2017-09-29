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
    
    var detail = false
    var photoURL: URL?
    
    func displayTweet(_ tweet: Tweet) {
        nameLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        screenNameLabel.text = tweet.user?.atScreenName
        dateIntervalLabel.text = tweet.prettyInterval
        if let url = tweet.user?.profileURL {
            profileImageView.setImageWith(url)
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
    
    func displayRetweet(_ tweet: Tweet) {
        extraStatusView.isHidden = false
        if let url = tweet.user?.profileURL {
            retweetProfileImage.setImageWith(url)
        }
        dateIntervalLabel.text = tweet.prettyInterval
        retweetNameLabel.text = tweet.user?.name
        retweetImage.image = #imageLiteral(resourceName: "retweet-1-16")
    }
    
    func configureDetail() {
        dateIntervalLabel.isHidden = true
        textLabel?.font.withSize(22.0)
    }
    
    var tweet: Tweet! {
        didSet {
            if tweet.retweetedTweet != nil {
                displayTweet(tweet.retweetedTweet!)
                displayRetweet(tweet)
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
