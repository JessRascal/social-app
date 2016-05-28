//
//  FirebaseAuth.swift
//  justonejess-social
//
//  Created by Jess Rascal on 21/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuth {
    
    func authenticate(credential: FIRAuthCredential, vc: AuthVC, providerIn: String) {
        // Authenticate the passed in credential with Firebase.
        FIRAuth.auth()?.signInWithCredential(credential) { user, error in
            if error != nil {
                print("Unable to authenticate \(providerIn) credentials with Firebase. Error: \(error!.localizedDescription)")
                print(error)
                vc.displayOkAlert("\(providerIn) Login Failed", message: "Unable to log in via \(providerIn), please try again.")
            } else {
                print("\(providerIn) account successfully authenticated with Firebase")
                
                if let user = user {
                    // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                    vc.saveUserId(user.uid)
                    
                    // Attempt to create a new user (will just perform required updates if user already exists).
                    vc.createNewUser(user.uid, provider: credential.provider)
                    
                    // Take the logged in user to the feed screen.
                    vc.goToFeedVC()
                } else {
                    print("The user data was not returned from Firebase")
                }
            }
        }
    }
}