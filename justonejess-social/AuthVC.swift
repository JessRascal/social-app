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

class AuthVC: UIViewController/*, GIDSignInDelegate, GIDSignInUIDelegate*/ {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates.
//        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    
    // Facebook login.
    @IBAction func fbBtnTapped(sender: UIButton!) {
        
        
        // MOVE THIS GUARD STEMENT IN TO THE FacebookAuth CLASS AS WELL?????????????
        
        
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
        
        
        
        
        
        //        TWITTER_AUTH_HELPER.selectTwitterAccountWithCallback({ error, accounts in
        //
        //            if error != nil {
        //                print("Unable to retrieve the Twitter accounts")
        //                self.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
        //            } else if accounts.count == 1 {
        //
        //                // Get the Twitter account.
        //                let account = accounts[0] as? ACAccount
        //
        //                // Authenticate the Twitter user.
        //                TWITTER_AUTH_HELPER.authenticateAccount(account, withCallback: { error, authData in
        //
        //                    if error != nil {
        //                        print("Unable to authenticate the selected Twitter account")
        //                        self.displayOkAlert("Error", message: error.localizedDescription)
        //                    } else {
        //                        print("Twitter account successfully logged in")
        //
        //                        // Attempt to create a new user (will just perform required updates if user already exists).
        //                        self.createNewUser(authData.uid, provider: authData.provider)
        //
        //                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
        //                        self.saveUserId(authData.uid)
        //
        //                        // Take the logged in user to the feed screen.
        //                        self.goToFeedVC()
        //                    }
        //                })
        //            } else if accounts.count > 1 {
        //                // Create an action sheet to add the available Twitter accounts to.
        //                let actionSheetController = UIAlertController(title: "Select Twitter Account", message: nil, preferredStyle: .ActionSheet)
        //                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        //                actionSheetController.addAction(cancelAction)
        //
        //                // Enumerate through the available Twitter accounts.
        //                for account in accounts {
        //
        //                    // Create an alert action for the account.
        //                    let twitterAccountAction = UIAlertAction(title: "@\(account.username)", style: .Default, handler: { action in
        //
        //                        let twitterHandle = action.title?.stringByReplacingOccurrencesOfString("@", withString: "")
        //                        for account in TWITTER_AUTH_HELPER.accounts {
        //                            if twitterHandle == account.username {
        //
        //                                // Authenticate the Twitter user.
        //                                TWITTER_AUTH_HELPER.authenticateAccount(account as! ACAccount, withCallback: { error, authData in
        //
        //                                    if error != nil {
        //                                        print("Unable to authenticate the selected Twitter account")
        //                                        self.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
        //                                    } else {
        //                                        print("Twitter account successfully logged in")
        //
        //                                        // Attempt to create a new user (will just perform required updates if user already exists).
        //                                        self.createNewUser(authData.uid, provider: authData.provider)
        //
        //                                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
        //                                        self.saveUserId(authData.uid)
        //
        //                                        // Take the logged in user to the feed screen.
        //                                        self.goToFeedVC()
        //                                    }
        //
        //                                })
        //                            }
        //                        }
        //                    })
        //                    actionSheetController.addAction(twitterAccountAction)
        //                }
        //                self.presentViewController(actionSheetController, animated: true, completion: nil)
        //            }
        //        })
    }
    // Twitter login end.
    
    
    
    // Google login.
    @IBAction func googleBtnTapped(sender: UIButton!) {
        // TODO - Check for existing Google access token to skip straight to FeedVC and saving uid with new user creation being skipped.
//                GIDSignIn.sharedInstance().signIn()
        let auth = GoogleAuth(authVC: self)
        auth.authenticate()
    }
    
//    // Log in to Google.
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
//        if error != nil {
//            print("Google login failed - \(error)")
//            self.displayOkAlert("Google Login Failed", message: error.localizedDescription)
//        } else {
//            let authentication = user.authentication
//            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
//            
//            // Authenticate the Facebook login with Firebase.
//            FirebaseAuth().authenticate(credential, vc: self, providerIn: "Google")
//        }
//    }
    // Google login end.
    
    
    
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
        DataService.ds.createFirebaseUser(uid, user: userData)
    }
    
    func saveUserId(uid: String) {
        NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
    }
    
    func goToFeedVC() {
        //        performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        
        let feedVC = self.storyboard!.instantiateViewControllerWithIdentifier("FeedVC") as UIViewController
        //        sideNavigationController?.transitionFromRootViewController(feedVC)
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
        // Sign out of Google.
        //        GIDSignIn.sharedInstance().signOut()
        // Unauthenticate the user.
        //        DataService.ds.REF_BASE.unauth() // REMOVES ACCESS TOKEN SO APPS HAVE TO AUTHROISE EVERY TIME
        // Clear the saved UID in the user defaults.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        print("The user has been logged out")
    }
    
}

