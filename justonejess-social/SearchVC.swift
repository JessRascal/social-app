//
//  SearchVC.swift
//  justonejess-social
//
//  Created by Jess Rascal on 05/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func backButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil) // CUSTOM TRANSITION TO MAKE IT SLIDE OFF TO THE RIGHT INSTEAD OF DOWN?
    }
}
