//
//  HamburgerMenuViewController.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 10/5/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!

    var menuIsOpen: Bool = false

    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()
            if oldMenuViewController != nil {
                oldMenuViewController.willMove(toParentViewController: nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMove(toParentViewController: nil)
            }
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }

    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            closeMenu()
        }
    }

    var originalLeftMargin: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func closeMenu() {
        menuIsOpen = false
        UIView.animate(withDuration: 0.3) {
            self.leftMarginConstraint.constant = 0
            self.contentView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }

    fileprivate func openMenu() {
        menuIsOpen = true
        UIView.animate(withDuration: 0.3) {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 100
            self.contentView.alpha = 0.5
            self.view.layoutIfNeeded()
        }
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        switch sender.state {
        case .began:
            if velocity.x < 0  && !menuIsOpen {
                sender.isEnabled = false
                sender.isEnabled = true
            }
            originalLeftMargin = leftMarginConstraint.constant
        case .changed:
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        case .ended:
            if velocity.x > 0 {
                openMenu()
            } else {
                closeMenu()
            }
        default:
            break
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
