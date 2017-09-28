//
//  TimelineViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/27/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = [Tweet]()
    var maxId: Int?
    var spinner: UIActivityIndicatorView?
    var refreshControl: UIRefreshControl?
    var isDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner!.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
        spinner?.stopAnimating()
        tableView.tableFooterView = spinner

        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(loadTweets(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        
        loadTweets(nil)
    }

    @objc func loadTweets(_ refreshControl: UIRefreshControl?) {
        isDataLoading = true
        spinner?.startAnimating()
        if refreshControl != nil {
            maxId = nil
        }
        TwitterClient.shared.homeTimeline(fromId: maxId) { (tweets, error) in
            self.isDataLoading = false
            self.spinner?.stopAnimating()
            refreshControl?.endRefreshing()
            if let tweets = tweets {
                if self.maxId != nil {
                    self.tweets.append(contentsOf: tweets)
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

    // MARK: - UITableViewDataSource
    
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
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.shared.logout()
    }
    

}
