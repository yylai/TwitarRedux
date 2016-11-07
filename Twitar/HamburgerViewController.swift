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
            
        } else if sender.state == .changed {
            
            leftMarginContentConstraint.constant = originalLeftMargin + translation.x
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
