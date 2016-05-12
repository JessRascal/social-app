//
//  JOJPostCard.swift
//  justonejess-social
//
//  Created by Jess Rascal on 05/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Material

class JOJPostCard: ImageCardView {
    
    override func prepareView() {
        super.prepareView()
        preparePostCard()
    }
    
    func preparePostCard() {
        depth = .Depth1
    }
}
