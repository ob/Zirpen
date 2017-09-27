//
//  LoginViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/26/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!,
                                                    consumerKey: "ZuByPvIFnaqRCHS4SgRgIYZ8E",
                                                    consumerSecret: "cveQTM3xvOtbatFgASRKJZS3AoXjPlWtKMHcfeKnUNmMKSOSXR")
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "zirpen://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a token")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken.token)!
            print("URL == \(url)")
            UIApplication.shared.open(url, options: [String:Any](), completionHandler: nil)
        }, failure: { (error: Error?) in
            print("error: \(error!.localizedDescription)")
        })

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
