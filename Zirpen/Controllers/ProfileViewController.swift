//
//  ProfileViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/5/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    var user: User! {
        didSet {
            view.layoutIfNeeded()
            if let url = user.profileBannerURL {
                backgroundImageView.setImageWith(url)
            }
            if let url = user.profileURL {
                avatarImageView.setImageWith(url)
            }
            nameLabel.text = user.name
            screenNameLabel.text = user.atScreenName
            taglineLabel.text = user.tagline
            followersCountLabel.attributedText = user.prettyFollowersCount
            followingCountLabel.attributedText = user.prettyFollowingCount
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        avatarImageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        backgroundImageView.alpha = 0.8
        backgroundImageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        doneButton.accessibilityElementsHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
