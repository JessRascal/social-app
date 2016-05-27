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

class GoogleAuth: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var vc: AuthVC!
    //    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AuthVC") as UIViewController
    let provider = "Google"
    
    init(authVC: AuthVC) {
        super.init()
        vc = authVC
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func authenticate() {
//        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
//        //        GIDSignIn.sharedInstance().uiDelegate = self
        
//        GIDSignIn.sharedInstance().signInSilently()
        
        
        GIDSignIn.sharedInstance().signIn()
//        signIn(GIDSignIn.sharedInstance(), didSignInForUser: GIDSignIn.sharedInstance().currentUser, withError: NSError!)
    }
    
    // Log in to Google.
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print("\(provider) login failed - \(error)")
            vc.displayOkAlert("\(provider) Login Failed", message: error.localizedDescription)
        } else {
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
            
            // Authenticate the Facebook login with Firebase.
            FirebaseAuth().authenticate(credential, vc: vc, providerIn: provider)
        }
    }
    
    //    // Stop the UIActivityIndicatorView animation that was started when the user
    //    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        //        vc.presentViewController(viewController, animated: true, completion: nil)
//        vc.presentViewController(viewController, animated: true, completion: nil)
         self.vc.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        vc.dismissViewControllerAnimated(true, completion: nil)
    }
}
