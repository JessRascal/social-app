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
let TWITTER_API_KEY = "J9jqv3tWEOycMo4wjAXVPw1jC"

// Segues
let SEGUE_LOGGED_IN = "loggedIn"
let SEGUE_SEARCH_VIEW = "showSearch"
let SEGUE_NEW_POST = "showNewPost"
let SEGUE_LOGGED_OUT = "loggedOut"

// Status codes
let STATUS_ACCOUNT_NONEXIST = -8

// Helpers
let TWITTER_AUTH_HELPER = TwitterAuthHelper(firebaseRef: DataService.ds.REF_BASE, apiKey: TWITTER_API_KEY)

// Storyboard IDs
let SIDE_NAV_VC = "SideNavVC"