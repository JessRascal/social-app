//
//  Constants.swift
//  justonejess-social
//
//  Created by Jess Rascal on 25/04/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Firebase

let SHADOW_COLOUR: CGFloat = 157.0 / 255.0

// Keys
let KEY_UID = "uid"

// Segues
let SEGUE_LOGGED_IN = "loggedIn"
let SEGUE_SEARCH_VIEW = "showSearch"
let SEGUE_NEW_POST = "showNewPost"
let SEGUE_LOGGED_OUT = "loggedOut"

// Status codes
let EMAIL_ACCOUNT_NONEXIST = -8 // NEEDS CHANGING TO CORRECT CODE FOR FIREBASE SDK 3!
let GOOGLE_CANCELLED_CODE = -5
let TWITTER_CANCELLED_CODE = 1

// Storyboard IDs
let SIDE_NAV_VC = "SideNavVC"