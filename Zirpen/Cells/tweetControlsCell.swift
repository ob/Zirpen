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
            if !(tweet.favorited ?? false) {
                favouriteButton.imageView?.image = #imageLiteral(resourceName: "favorite-4-16")
            } else {
                favouriteButton.imageView?.image = #imageLiteral(resourceName: "favorite-full-16")
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
