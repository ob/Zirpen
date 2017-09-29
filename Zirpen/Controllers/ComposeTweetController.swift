//
//  ComposeTweetController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/28/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class ComposeTweetController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        if let user = User.currentUser,
            let url = user.profileURL {
            avatarImageView.setImageWith(url)
        }
        countLabel.text = "140"
        tweetButton.isEnabled = false
        tweetTextField.delegate = self
        tweetTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.count ?? 0) + text.count - range.length
        updateCountLabel(newLength)
        return true
    }
    
    func updateCountLabel(_ length: Int) {
        let remaining = 140 - length
        if remaining < 0 {
            countLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            tweetButton.isEnabled = false
        } else {
            countLabel.textColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
            tweetButton.isEnabled = true
        }
        countLabel.text = String(remaining)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
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
