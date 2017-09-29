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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add an empty footer to disable showing empty cells
        // as per: https://stackoverflow.com/questions/14520185/how-to-remove-empty-cells-in-uitableview
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photoURL != nil {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0  && photoURL != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageDetailCell", for: indexPath) as! ImageDetailCell
            cell.photoURL = photoURL
            return cell

        }
        // not a photo let's see if it's the tweet
        if (indexPath.row == 0 && photoURL == nil) || (indexPath.row == 1 && photoURL != nil) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? tweetCell {
                cell.detail = true
                cell.tweet = tweet
                return cell
            }
        }
        // it's the status
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetStatsCell", for: indexPath) as? TweetStatsCell {
            cell.tweet = tweet
            return cell
        }
        return UITableViewCell()
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
