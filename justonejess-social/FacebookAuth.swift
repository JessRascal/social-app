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
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: vc, handler: { facebookResult, facebookError -> Void in
            if facebookError != nil {
                print("\(self.provider) login failed - \(facebookError)")
                vc.displayOkAlert("\(self.provider) Login Failed", message: facebookError.localizedDescription)
            } else if facebookResult.isCancelled {
                print("\(self.provider) login was cancelled")
            } else {
                // Authenticate the Facebook login with Firebase.
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FirebaseAuth().authenticate(credential, vc: vc, providerIn: self.provider)
            }
        })
    }
}