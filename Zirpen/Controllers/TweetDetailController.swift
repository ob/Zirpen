//
//  TweetDetailController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/28/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var extraStatusView: UIStackView!
    @IBOutlet weak var retweetProfileImage: UIImageView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        retweetProfileImage.layer.cornerRadius = retweetProfileImage.frame.size.width / 2
        retweetProfileImage.clipsToBounds = true

        var t = tweet
        if tweet.retweetedTweet != nil {
            t = tweet.retweetedTweet!
            extraStatusView.isHidden = false
            if let url = tweet.user?.profileURL {
                retweetProfileImage.setImageWith(url)
            }
            retweetNameLabel.text = tweet.user?.name
        } else {
            extraStatusView.isHidden = true
        }
        nameLabel.text = t?.user?.name
        textLabel.text = t?.text
        screenNameLabel.text = t?.user?.atScreenName
        if let url = t?.user?.profileURL {
            profileImageView.setImageWith(url)
        }
        if let media = t?.media {
            switch media {
            case .photo(let url):
                imgView.clipsToBounds = true
                imgView.contentMode = .scaleAspectFit
                imgView.setImageWith(url)
                imgView.isHidden = false
            }
        } else {
            imgView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
