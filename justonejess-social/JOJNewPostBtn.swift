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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure the button.
        self.setImage(btnImage, forState: .Normal)
        self.setImage(btnImage, forState: .Highlighted)
    }
}