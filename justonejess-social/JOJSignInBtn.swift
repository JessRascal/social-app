//
//  JOJSignInBtn.swift
//  justonejess-social
//
//  Created by Jess Rascal on 12/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJSignInBtn: FabButton {
    override func prepareView() {
        super.prepareView()
        prepareButton()
    }
    
    func prepareButton() {
        depth = .Depth2
        backgroundColor = MaterialColor.teal.accent3
        tintColor = MaterialColor.white
    }
}
