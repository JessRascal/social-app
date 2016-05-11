//
//  JOJSearchBar.swift
//  justonejess-social
//
//  Created by Jess Rascal on 04/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Material

class JOJSearchBar: SearchBar {
    
    let backImage = MaterialIcon.arrowBack!
    let backButton = FlatButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure back button.
        configureButton(backButton, btnImage: backImage)
        
        // Add buttons.
        self.leftControls = [backButton]
        
        // Add button actions.
        backButton.addTarget(nil, action: #selector(SearchVC.backButtonTapped), forControlEvents: .TouchUpInside)
        
        // Configure general search bar style.
        self.statusBarStyle = .Default
        self.placeholder = "Search for a place"
        self.textField.font = RobotoFont.regular // NEEDS TO BE NOTO SANS
    }
    
    func configureButton(btn: FlatButton, btnImage: UIImage) {
        btn.pulseScale = false
        btn.pulseColor = MaterialColor.black // NEEDS ALPHA 87% OR 54%
        btn.tintColor = MaterialColor.black // NEEDS ALPHA 87% OR 54%
        btn.setImage(btnImage, forState: .Normal)
        btn.setImage(btnImage, forState: .Highlighted)
    }
}
