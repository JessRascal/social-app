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

class GoogleAuth: NSObject, GIDSignInDelegate/*, GIDSignInUIDelegate*/ {
    
    let vc = AuthVC()
    let provider = "Google"
    
    // Log in to Google.
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print("\(provider) login failed - \(error)")
            vc.displayOkAlert("\(provider) Login Failed", message: error.localizedDescription)
        } else {
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
            
            // Authenticate the Facebook login with Firebase.
            FirebaseAuth().authenticate(credential, vc: vc, providerIn: credential.provider)
        }
    }
}
