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
    let searchBtn = FlatButton()
    let searchBtnImage: UIImage = MaterialIcon.place!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure controls.
        configureButton(moreBtn, btnImage: moreBtnImage)
        configureButton(searchBtn, btnImage: searchBtnImage)
        
        // Add controls to toolbar.
        self.leftControls = [moreBtn]
        self.rightControls = [searchBtn]
        
        // Add button actions.
        searchBtn.addTarget(nil, action: #selector(FeedVC.placeButtonTapped), forControlEvents: .TouchUpInside) // Best way to do this?
        
        // Set title.
        configureLabel(toolbarTitle)
        self.titleLabel = toolbarTitle
        
        // Set toolbar styles.
        self.backgroundColor = MaterialColor.teal.base
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
