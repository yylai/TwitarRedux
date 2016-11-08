//
//  HamburgerViewController.swift
//  Twitar
//
//  Created by YINYEE LAI on 11/6/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginContentConstraint: NSLayoutConstraint!
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            
            
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
            
        }
    }
    
    var cvController: UIViewController! {
        didSet(oldContentVC) {
            view.layoutIfNeeded()
            
            if oldContentVC != nil {
                oldContentVC.willMove(toParentViewController: nil)
                oldContentVC.view.removeFromSuperview()
                oldContentVC.didMove(toParentViewController: nil)
            }
            
            
            cvController.willMove(toParentViewController: self)
            contentView.addSubview(cvController.view)
            cvController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginContentConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    var originalLeftMargin: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            
            originalLeftMargin = leftMarginContentConstraint.constant
            print("original left: \(originalLeftMargin)")
            
        } else if sender.state == .changed {
            
            leftMarginContentConstraint.constant = originalLeftMargin + translation.x
            print("new left: \(leftMarginContentConstraint.constant)")
            
        } else if sender.state == .ended {
            
            
            UIView.animate(withDuration: 0.3, animations: {
                //opening
                if velocity.x > 0 {
                    self.leftMarginContentConstraint.constant = self.view.frame.size.width - 50
                } else {
                    //closing
                    self.leftMarginContentConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
        }
        
    }

}
