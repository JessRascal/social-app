//
//  ViewController.swift
//  justonejess-social
//
//  Created by Jess Rascal on 25/04/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class AuthVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let googleAuth = GoogleAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleAuth.vc = self
        
        // Setup Google sign in delegates.
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
        GIDSignIn.sharedInstance().delegate = googleAuth
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // Facebook login.
    @IBAction func fbBtnTapped(sender: UIButton!) {
        // Check if the user already has a valid current access token.
        // This avoids the user having to reauthorise the app with Facebook every time they log in.
        
        // Check that a current access token exists.
        guard FBSDKAccessToken.currentAccessToken() != nil else {
            // If not then perform a new authentication.
            FacebookAuth().authenticate(self)
            return
        }
        // Check the current access token hasn't expired.
        let dateOrder = NSDate().compare(FBSDKAccessToken.currentAccessToken().expirationDate)
        guard dateOrder == .OrderedAscending else {
            // If not then perform a new authentication.
            FacebookAuth().authenticate(self)
            return
        }
        // Check the user has authData and assign it to a constant.
        guard let user = FIRAuth.auth()?.currentUser else {
            // If not then perform a new authentication.
            FacebookAuth().authenticate(self)
            return
        }
        
        //Store the user's uid to the UserDefaults so it is retained when the app is closed.
        saveUserId(user.uid)
        
        // Take the logged in user to the feed screen.
        goToFeedVC()
    }
    // Facebook login end.
    
    // Twitter Login
    @IBAction func twitterBtnTapped(sender: UIButton!) {
        TwitterAuth().authenticate(self)
    }
    
    // Google login.
    @IBAction func googleBtnTapped(sender: UIButton!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    // Email login. // REFACTOR ONCE NEW EMAIL LOGIN WORKFLOW IS CREATED.
    //    @IBAction func attemptLogin(sender: UIButton!) {
    //        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
    //
    //            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
    //
    //                if error != nil {
    //                    print(error)
    //
    //                    if error.code == STATUS_ACCOUNT_NONEXIST {
    //                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
    //
    //                            if error != nil { // INCLUDE ALL SCENARIOS.
    //                                self.displayOkAlert("Could Not Create Account", message: "Problem creating the account. Try something else")
    //                            } else {
    //                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
    //
    //                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (err, authData) in
    //                                    let user = ["provider": authData.provider!]
    //                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
    //                                })
    //
    //                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    //                            }
    //
    //                        })
    //                    } else {
    //                        self.displayOkAlert("Could Not Log In", message: "Please check your username and password.")
    //                    }
    //                } else {
    //                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    //                }
    //
    //            })
    //
    //        } else {
    //            displayOkAlert("Email and Password Required", message: "You must enter an email and password.")
    //        }
    //    }
    // Email login end.
    
    
    
    // Alert functions.
    func displayOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Login helper functions.
    func createNewUser(uid: String, provider: String) {
        let userData = ["provider": provider]
        DataService.ds.saveUserData(userData)
    }
    
    func saveUserId(uid: String) {
        NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
    }
    
    func goToFeedVC() {
        
        let feedVC = self.storyboard!.instantiateViewControllerWithIdentifier("FeedVC") as UIViewController
        sideNavigationController?.transitionFromRootViewController(feedVC,
                                                                   duration: 1,
                                                                   options: .TransitionNone,
                                                                   animations: nil,
                                                                   completion: { [weak self] _ in
                                                                    self?.sideNavigationController?.closeLeftView()
            })
    }
    
    // Log out the user.
    func logOut() {
        // Clear the saved UID in the user defaults.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        print("The user has been logged out")
    }
    
}

