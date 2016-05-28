//
//  FacebookAuth.swift
//  justonejess-social
//
//  Created by Jess Rascal on 18/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class FacebookAuth {
    
    let provider = "Facebook"
    
    func authenticate(vc: AuthVC) {
        let facebookLogin = FBSDKLoginManager()
        
        // Log in to Facebook.
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: vc, handler: { result, error -> Void in
            if error != nil {
                print("\(self.provider) login failed - \(error)")
                vc.displayOkAlert("\(self.provider) Login Failed", message: error.localizedDescription)
            } else if result.isCancelled {
                print("The user denied the app access to their \(self.provider) account")
            } else {
                print("Successfully logged in to \(self.provider).")
                // Authenticate the Facebook login with Firebase.
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FirebaseAuth().authenticate(credential, vc: vc, providerIn: self.provider)
            }
        })
    }
}