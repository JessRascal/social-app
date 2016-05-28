//
//  GoogleAuth.swift
//  justonejess-social
//
//  Created by Jess Rascal on 20/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class GoogleAuth: NSObject, GIDSignInDelegate {
    
    var vc: AuthVC! = nil
    let provider = "Google"
    
    // Log in to Google.
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            switch error.code {
            case GOOGLE_CANCELLED_CODE:
                print("The user denied the app access to their \(provider) account")
                break
            default:
                vc.displayOkAlert("\(provider) Login Failed", message: error.localizedDescription)
                print("\(provider) login failed - \(error)")
                break
            }
        } else {
            print("Successfully logged in to \(self.provider) as \(user.profile.email)")
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
            
            // Authenticate the Facebook login with Firebase.
            if vc != nil {
                FirebaseAuth().authenticate(credential, vc: vc, providerIn: provider)
            } else {
                vc.displayOkAlert("\(self.provider) Sign In Error", message: "Unable to sign in to \(self.provider) with the selected account, please try again.")
                print("Unable to log in to \(self.provider) because no authVC was defined.")
            }
            
        }
    }
}
