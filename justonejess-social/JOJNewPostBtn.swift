//
//  JOJNewPostBtn.swift
//  justonejess-social
//
//  Created by Jess Rascal on 04/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Material

class JOJNewPostBtn: FabButton {
    let btnImage: UIImage = MaterialIcon.add!
    
    override func prepareView() {
        super.prepareView()
        prepareButton()
    }
    
    func prepareButton() {
        depth = .Depth2
        tintColor = MaterialColor.white
        setImage(btnImage, forState: .Normal)
        setImage(btnImage, forState: .Highlighted)
    }
}