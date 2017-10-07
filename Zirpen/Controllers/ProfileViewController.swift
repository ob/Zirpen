//
//  ProfileViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/5/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit
import FXBlurView

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    var headerImageView: UIImageView!
    var headerBlurImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var user: User! {
        didSet {
            view.layoutIfNeeded()
            if let url = user.profileURL {
                avatarImageView.setImageWith(url)
            }
            nameLabel.text = user.name
            headerLabel.text = user.name
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        scrollView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)

        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)

        header.clipsToBounds = true

        if let url = user.profileBannerURL {
            headerImageView?.setImageWith(URLRequest.init(url: url), placeholderImage: nil, success: { (request, response, image) in
                self.headerImageView.image = image
                self.headerBlurImageView.image = image.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
            }, failure: { (request, response, error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)

            header.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)

            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform

            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)

            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImageView.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImageView.bounds.height * (1.0 + avatarScaleFactor)) - avatarImageView.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)

            if offset <= offset_HeaderStop {

                if avatarImageView.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }

            }else {
                if avatarImageView.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }

        // Apply Transformations

        header.layer.transform = headerTransform
        avatarImageView.layer.transform = avatarTransform

    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
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
