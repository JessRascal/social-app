//
//  SideVC.swift
//  justonejess-social
//
//  Created by Jess Rascal on 16/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class SideNavVC: UIViewController {
    
    var authVC = AuthVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutBtnTapped(sender: AnyObject) {
        authVC = self.storyboard!.instantiateViewControllerWithIdentifier("AuthVC") as! AuthVC
        
        authVC.logOut()
        //        performSegueWithIdentifier(SEGUE_LOGGED_OUT, sender: nil)
        //        sideNavigationController?.transitionFromRootViewController(authVC)
        
        //        let feedVC = self.storyboard!.instantiateViewControllerWithIdentifier("AuthVC") as UIViewController
        sideNavigationController?.transitionFromRootViewController(authVC,
                                                                   duration: 1,
                                                                   options: .TransitionNone,
                                                                   animations: nil,
                                                                   completion: { [weak self] _ in
                                                                    self?.sideNavigationController?.closeLeftView()
            })
    }
    
}
