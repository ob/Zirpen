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

    var tweet: Tweet?

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var howLongAgoLabel: UILabel!
    @IBOutlet weak var favoritedImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    
    @IBOutlet var contentView: UIView!

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
}
