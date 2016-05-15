//
//  DataService.swift
//  justonejess-social
//
//  Created by Jess Rascal on 27/04/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://justonejess-social.firebaseio.com"

class DataService {
    static let ds = DataService()

    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        // Update the user's data in Firebase or create it if it doesn't already exist.
        REF_USERS.childByAppendingPath(uid).updateChildValues(user)
    }
}