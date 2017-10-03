//
//  MiniTweetView.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/3/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class MiniTweetView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var howLongAgoLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = tweet.user?.atScreenName
            howLongAgoLabel.text = tweet.prettyInterval
            if let url = tweet.imageURL {
                imageView.isHidden = false
                imageView.setImageWith(url)
            } else {
                imageView.isHidden = true
            }
            tweetTextLabel.attributedText = tweet.prettyText
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
        Bundle.main.loadNibNamed("MiniTweetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        imageView.clipsToBounds = true
    }

}
