//
//  JOJMaterialToolbar.swift
//  justonejess-social
//
//  Created by Jess Rascal on 04/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJMainToolbar: Toolbar {
    let toolbarTitle = UILabel()
    let moreBtn = FlatButton()
    let moreBtnImage: UIImage = MaterialIcon.moreVertical!
    let placeBtn = FlatButton()
    let placeBtnImage: UIImage = MaterialIcon.place!
    
    override func prepareView() {
        super.prepareView()
        prepareToolbar()
    }
    
    func prepareToolbar() {
        // Set toolbar styles.
        backgroundColor = MaterialColor.teal.base
        depth = .Depth2
        statusBarStyle = .LightContent
        
        // Configure title.
        configureLabel(toolbarTitle)
        titleLabel = toolbarTitle
        
        // Configure more button.
        configureButton(moreBtn, btnImage: moreBtnImage)
        
        // Configure place button.
        configureButton(placeBtn, btnImage: placeBtnImage)
        
        // Add place button action.
        placeBtn.addTarget(nil, action: #selector(FeedVC.placeButtonTapped), forControlEvents: .TouchUpInside) // Best way to do this?
        
        // Add buttons to the left.
        leftControls = [moreBtn]
        
        // Add buttons to the right.
        rightControls = [placeBtn]
        
    }
    
    func configureButton(btn: FlatButton, btnImage: UIImage) {
        btn.pulseColor = MaterialColor.white
        btn.pulseScale = false
        btn.tintColor = MaterialColor.white
        btn.setImage(btnImage, forState: .Normal)
        btn.setImage(btnImage, forState: .Highlighted)
    }
    
    func configureLabel(label: UILabel) {
        label.text = "Wetherspoons, Leeds"
        label.textAlignment = .Center
        label.textColor = MaterialColor.white
    }
}
