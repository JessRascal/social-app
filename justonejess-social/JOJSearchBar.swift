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
    
    let backImage = MaterialIcon.cm.arrowBack!
    let backButton = FlatButton()
    
    override func prepareView() {
        super.prepareView()
        prepareSearchBar()
    }
    
    func prepareSearchBar() {
        
        // Set searchbar styles.
        depth = .Depth2
        statusBarStyle = .Default
    
        // Configure back button.
        configureButton(backButton, btnImage: backImage)
        
        // Add left buttons.
        leftControls = [backButton]
        
        // Add button actions.
        backButton.addTarget(nil, action: #selector(SearchVC.backButtonTapped), forControlEvents: .TouchUpInside)
        
        // Configure search field.
        placeholder = "Search for a place"
        textField.font = RobotoFont.regular // NEEDS TO BE NOTO SANS
    }
    
    func configureButton(btn: FlatButton, btnImage: UIImage) {
        btn.pulseScale = false
//        btn.pulseColor = MaterialColor.black // NEEDS ALPHA 87% OR 54%
//        btn.tintColor = MaterialColor.black // NEEDS ALPHA 87% OR 54%
        btn.pulseColor = MaterialColor.grey.base
        btn.tintColor = MaterialColor.grey.darken4
        btn.setImage(btnImage, forState: .Normal)
        btn.setImage(btnImage, forState: .Highlighted)
    }
}
