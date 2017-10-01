//
//  tweetControlsCell.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/29/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class tweetControlsCell: UITableViewCell {

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            updateLabels(tweet)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteButton.setImage(#imageLiteral(resourceName: "favorite-full-4-32"), for: .selected)
        favouriteButton.setImage(#imageLiteral(resourceName: "favorite-4-32"), for: .normal)
        if tweet != nil {
            updateLabels(tweet)
        }
    }

    func updateLabels(_ tweet: Tweet) {
        var faved = tweet.favorited
        if tweet.retweetedTweet != nil {
            faved = tweet.retweetedTweet!.favorited
        }
        favouriteButton.isSelected = faved
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
