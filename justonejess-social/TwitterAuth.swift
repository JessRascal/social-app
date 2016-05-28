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
                print("Successfully logged in to \(self.provider) as \(unwrappedSession.userName)")
                // Authenticate the Facebook login with Firebase.
                let credential = FIRTwitterAuthProvider.credentialWithToken(unwrappedSession.authToken, secret: unwrappedSession.authTokenSecret)
                FirebaseAuth().authenticate(credential, vc: vc, providerIn: self.provider)
            } else {
                if let error = error {
                    switch error.code {
                    case 1: TWITTER_CANCELLED_CODE
                        print("The user denied the app access to their \(self.provider) account")
                        break
                    default:
                        vc.displayOkAlert("\(self.provider) Sign In Error", message: "Unable to sign in to \(self.provider) with the selected account, please try again.")
                        print("\(self.provider) login error: \(error.localizedDescription)")
                        break
                    }
                }
            }
        }
    }
}
