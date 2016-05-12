//
//  NewPostVC.swift
//  justonejess-social
//
//  Created by Jess Rascal on 11/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil) // // CUSTOM TRANSITION TO MAKE IT MINIMIZE DOWN TO THE BOTTOM RIGHT/TO THE FAB BUTTON??
    }

}
