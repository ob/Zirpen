//
//  ProfileViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/5/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit
import FXBlurView

let offset_HeaderStop:CGFloat = 40.0
let offset_B_LabelHeader:CGFloat = 95.0
let distance_W_LabelHeader:CGFloat = 35.0
let offset_tableView:CGFloat = 250.0

class ProfileViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet weak var tableView: UITableView!

    var maxId: Int?
    var spinner: UIActivityIndicatorView?
    var refreshControl: UIRefreshControl?
    var isDataLoading = false

    var onBackButton: (()->Void)?

    var tweets: [Tweet] = [Tweet]()

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

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()

        loadTweets(nil)
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

    @objc func loadTweets(_ refreshControl: UIRefreshControl?) {
        isDataLoading = true
        spinner?.startAnimating()
        if refreshControl != nil {
            maxId = nil
        }

        TwitterClient.shared.timeline(user: user, timeline: .UserTimeline, fromId: maxId) { (tweets, error) in
            self.isDataLoading = false
            self.spinner?.stopAnimating()
            refreshControl?.endRefreshing()
            if let tweets = tweets {
                if self.maxId != nil {
                    var newTweets = tweets
                    newTweets.removeFirst()
                    self.tweets.append(contentsOf: newTweets)
                } else {
                    self.tweets = tweets
                }
                self.maxId = tweets.last?.id
                self.tableView.reloadData()
            } else {
                print("error: \(error!.localizedDescription)")
            }
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

        print("offset = \(offset)")
        if scrollView == self.scrollView  && offset > offset_tableView {
            print("Scrolling tableView")
            self.scrollView.delaysContentTouches = false
            self.tableView.isScrollEnabled = true
        } else if scrollView == self.tableView && offset == 0.0 {
            print("Scrolling scrollView")
            self.scrollView.delaysContentTouches = true
            self.tableView.isScrollEnabled = false
        }
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

            } else {
                if avatarImageView.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }

        // Apply Transformations

        header.layer.transform = headerTransform
        avatarImageView.layer.transform = avatarTransform

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.tableView {
            scrollView.bounces = false
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? tweetCell {
            cell.tweet = tweets[indexPath.row]
            return cell
        }
        assert(false)
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tweets.count - 1 && !isDataLoading {
            loadTweets(nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TweetDetailController,
            let indexPath = tableView.indexPath(for: sender as! tweetCell) {
            vc.tweet = tweets[indexPath.row]
            vc.onDismiss = { [weak self] () in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            return
        }
        if let vc = segue.destination as? ComposeTweetController {
            vc.onDismiss = { (tweet) in
                self.tweets.insert(tweet, at: 0)
                self.tableView.reloadData()
            }
            return
        }
        if let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? ProfileViewController {
            if let user = sender as? User {
                vc.user = user
                return
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if onBackButton != nil {
            onBackButton!()
        } else {
            dismiss(animated: true, completion: nil)
        }
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
