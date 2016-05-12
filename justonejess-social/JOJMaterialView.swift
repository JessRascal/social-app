//
//  JOJMaterialView.swift
//  justonejess-social
//
//  Created by Jess Rascal on 11/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJMaterialView: MaterialView {
    
    override func prepareView() {
        super.prepareView()
        backgroundColor = MaterialColor.teal.base
        depth = .Depth2
    }
}
