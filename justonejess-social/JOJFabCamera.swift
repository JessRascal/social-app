//
//  JOJCameraBtn.swift
//  justonejess-social
//
//  Created by Jess Rascal on 12/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJFabCamera: JOJFabBtn {
    let btnImage: UIImage = MaterialIcon.photoCamera!
    
    override func prepareView() {
        super.prepareView()
        setBtnImage()
    }
    
    func setBtnImage() {
        setImage(btnImage, forState: .Normal)
        setImage(btnImage, forState: .Highlighted)
    }
}
