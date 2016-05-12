//
//  JOJMaterialTextField.swift
//  justonejess-social
//
//  Created by Jess Rascal on 12/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJMaterialTextField: TextField {
    override func prepareView() {
        super.prepareView()
        prepareField()
    }
    
    func prepareField() {
        backgroundColor = UIColor.clearColor()
        textColor = MaterialColor.white
        
        // Field inactive.
        lineLayerColor = MaterialColor.teal.accent4
        titleLabelColor = MaterialColor.teal.accent4
        
        // Field active.
        lineLayerActiveColor = MaterialColor.teal.accent3
        titleLabelActiveColor = MaterialColor.teal.accent3
    }
}
