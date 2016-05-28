//
//  TwitterAuth.swift
//  justonejess-social
//
//  Created by Jess Rascal on 18/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase
import Fabric
import TwitterKit

class TwitterAuth {
    
    let provider = "Twitter"
    
    func authenticate(vc: AuthVC) {
        
        // Log in to Twitter.
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if let unwrappedSession = session {
                print("Successfully logged in to Twitter as \(unwrappedSession.userName)")
                
                // Authenticate the Facebook login with Firebase.
                let credential = FIRTwitterAuthProvider.credentialWithToken(unwrappedSession.authToken, secret: unwrappedSession.authTokenSecret)
                FirebaseAuth().authenticate(credential, vc: vc, providerIn: self.provider)
            } else {
                vc.displayOkAlert("Sign In Error", message: "Unable to sign in to Twitter with the selected account, please try again.")
                print("Twitter login error: \(error!.localizedDescription)")
            }
        }
    }
}
