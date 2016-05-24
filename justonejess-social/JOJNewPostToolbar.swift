//
//  JOJPNewPostToolbar.swift
//  justonejess-social
//
//  Created by Jess Rascal on 11/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJNewPostToolbar: Toolbar {
    
    let cancelBtn = FlatButton()
    let cancelBtnImage: UIImage = MaterialIcon.clear!
    let addBtn = FlatButton()
    let addBtnImage: UIImage = MaterialIcon.add!
    
    override func prepareView() {
        super.prepareView()
        prepareToolbar()
    }
    
    func prepareToolbar() {
        // Set toolbar styles.
        backgroundColor = MaterialColor.teal.base
        depth = .None
        statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "NEW POST"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regular // NEED TO SET TO NOTO.
//        self.titleLabel = titleLabel
        
        // Configure cancel button.
        configureButton(cancelBtn, btnImage: cancelBtnImage)
        
        // Configure Add button.
        configureButton(addBtn, btnImage: addBtnImage)
        
        // Add cancel button action.
        cancelBtn.addTarget(nil, action: #selector(NewPostVC.cancelButtonTapped), forControlEvents: .TouchUpInside)
        
        // Add buttons to the left.
        leftControls = [cancelBtn]
        
        // Add buttons to the right.
        rightControls = [addBtn]
    }
    
    func configureButton(btn: FlatButton, btnImage: UIImage) {
        btn.pulseColor = MaterialColor.white
//        btn.pulseScale = false
        btn.tintColor = MaterialColor.white
        btn.setImage(btnImage, forState: .Normal)
        btn.setImage(btnImage, forState: .Highlighted)
    }
}