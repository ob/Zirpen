//
//  SideMenuViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/5/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var timelineNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!

    var hamburgerViewController: HamburgerMenuViewController!

    var viewControllers: [UIViewController] = []
    var titles = ["Timeline", "Profile", "Mentions"]

    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        if let url = User.currentUser?.profileURL {
            avatarImageView.setImageWith(url)
        }
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = User.currentUser?.atScreenName
        followersLabel.attributedText = User.currentUser?.prettyFollowersCount
        followingLabel.attributedText = User.currentUser?.prettyFollowingCount
        tableView.delegate = self
        tableView.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        if let vc = timelineNavigationController.childViewControllers.first as? TimelineViewController {
            vc.timeline = .Home
        }
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        if let vc = profileNavigationController.childViewControllers[0] as? ProfileViewController {
            vc.user = User.currentUser
        }
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        if let vc = mentionsNavigationController.childViewControllers.first as? TimelineViewController {
            vc.timeline = .Mentions
        }
        viewControllers.append(timelineNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)

        hamburgerViewController.contentViewController = timelineNavigationController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
