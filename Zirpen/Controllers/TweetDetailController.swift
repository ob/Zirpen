//
//  TweetDetailController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/28/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweet: Tweet! {
        didSet {
            if let media = tweet.media {
                switch media {
                case .photo(let url):
                    photoURL = url
                }
            }
        }
    }
    var photoURL: URL?
    var onDismiss: (() -> Void)?
    var cellsToReload: [IndexPath] = [IndexPath]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add an empty footer to disable showing empty cells
        // as per: https://stackoverflow.com/questions/14520185/how-to-remove-empty-cells-in-uitableview
        tableView.tableFooterView = UIView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        onDismiss?()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photoURL != nil {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = indexPath.row
        if photoURL == nil {
            row += 1
        }
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageDetailCell", for: indexPath) as! ImageDetailCell
            cell.photoURL = photoURL
            return cell

        }
        // not a photo let's see if it's the tweet
        if row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? tweetCell {
                cell.detail = true
                cell.tweet = tweet
                cellsToReload.append(indexPath)
                return cell
            }
        }
        if row == 2 {
            // it's the status
            if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetStatsCell", for: indexPath) as? TweetStatsCell {
                cell.tweet = tweet
                cellsToReload.append(indexPath)
                return cell
            }
        }
        if row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetControlsCell", for: indexPath) as? tweetControlsCell {
                cell.tweet = tweet
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        var tweet = self.tweet!
        if self.tweet.retweetedTweet != nil {
            tweet = self.tweet.retweetedTweet!
        }
        if !(tweet.retweeted) {
            TwitterClient.shared.retweet(tweet: tweet, completion: { (tweet, error) in
                if tweet != nil {
                    print("Retweeted")
                    tweet!.retweeted = true
                    tweet!.retweetCount = (tweet!.retweetCount ?? 0) + 1
                    self.tableView.reloadRows(at: self.cellsToReload, with: .none)
                } else {
                    print("Error retweeting")
                }
            })
        } else {
            TwitterClient.shared.unretweet(tweet: tweet, completion: { (tweet, error) in
                if tweet != nil {
                    print("Unretweeted")
                    tweet!.retweeted = false
                    tweet!.retweetCount = (tweet!.retweetCount ?? 1) - 1
                    self.tableView.reloadRows(at: self.cellsToReload, with: .none)
                } else {
                    print("Error unretweeting")
                }
            })
        }
    }

    @IBAction func onFavouriteButton(_ sender: Any) {
        var tweet = self.tweet!
        if self.tweet.retweetedTweet != nil {
            tweet = self.tweet.retweetedTweet!
        }
        if !(tweet.favorited) {
            TwitterClient.shared.favourite(tweet: tweet, completion: { (tweet, error) in
                if tweet != nil {
                    print("Favourited!")
                    tweet!.favorited = true
                    tweet!.favouritesCount = (tweet!.favouritesCount ?? 0) + 1
                    if let button = sender as? UIButton {
                        button.isSelected = true
                    }
                    self.tableView.reloadRows(at: self.cellsToReload, with: .none)
                } else {
                    print("Error")
                }
            })
        } else {
            TwitterClient.shared.unfavourite(tweet: tweet, completion: { (tweet, error) in
                if tweet != nil {
                    print("Unfavourited")
                    tweet!.favorited = false
                    tweet!.favouritesCount = (tweet!.favouritesCount ?? 1) - 1
                    if let button = sender as? UIButton {
                        button.isSelected = false
                    }
                    self.tableView.reloadRows(at: self.cellsToReload, with: .none)
                } else {
                    print("Error")
                }
            })
        }
    }

    @IBAction func onReplyButton(_ sender: Any) {
        performSegue(withIdentifier: "composeTweet", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for Segue")
        if let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers[0] as? ComposeTweetController {
            print("Passing on the tweet")
            vc.replyingTo = tweet
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
