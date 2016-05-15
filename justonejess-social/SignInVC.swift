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

class SignInVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Attempt to sign in silently, this will succeed if
        // the user has recently been authenticated.
//        GIDSignIn.sharedInstance().signInSilently() // Disabled because the app controls the auto sign ins.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            goToMainScreen()
//        }
    }
    
    
    
    // Facebook login.
    @IBAction func fbBtnTapped(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: { facebookResult, facebookError -> Void in
            
            if facebookError != nil {
                print("Facebook login failed - \(facebookError)")
                self.displayOkAlert("Facebook Login Failed", message: facebookError.localizedDescription)
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Unable to authenticate Facebook login")
                        self.displayOkAlert("Facebook Login Failed", message: error.localizedDescription)
                    } else {
                        print("Facebook account successfully logged in")
                        
                        // Attempt to create a new user (will just perform required updates if user already exists).
                        self.createNewUser(authData.uid, provider: authData.provider)
                        
                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                        self.saveUserId(authData.uid)
                        
                        // Take the logged in user to the feed screen.
                        self.goToFeedVC()
                    }
                })
            }
        })
    }
    // Facebook login end.
    
    
    
    // Twitter Login
    @IBAction func twitterBtnTapped(sender: UIButton!) {
        
        TWITTER_AUTH_HELPER.selectTwitterAccountWithCallback({ error, accounts in
            
            if error != nil {
                print("Unable to retrieve the Twitter accounts")
                self.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
            } else if accounts.count == 1 {
                
                // Get the Twitter account.
                let account = accounts[0] as? ACAccount
                
                // Authenticate the Twitter user.
                TWITTER_AUTH_HELPER.authenticateAccount(account, withCallback: { error, authData in
                    
                    if error != nil {
                        print("Unable to authenticate the selected Twitter account")
                        self.displayOkAlert("Error", message: error.localizedDescription)
                    } else {
                        print("Twitter account successfully logged in")
                        
                        // Attempt to create a new user (will just perform required updates if user already exists).
                        self.createNewUser(authData.uid, provider: authData.provider)
                        
                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                        self.saveUserId(authData.uid)
                        
                        // Take the logged in user to the feed screen.
                        self.goToFeedVC()
                    }
                })
            } else if accounts.count > 1 {
                // Create an action sheet to add the available Twitter accounts to.
                let actionSheetController = UIAlertController(title: "Select Twitter Account", message: nil, preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                actionSheetController.addAction(cancelAction)
                
                // Enumerate through the available Twitter accounts.
                for account in accounts {
                    
                    // Create an alert action for the account.
                    let twitterAccountAction = UIAlertAction(title: "@\(account.username)", style: .Default, handler: { action in
                        
                        let twitterHandle = action.title?.stringByReplacingOccurrencesOfString("@", withString: "")
                        for account in TWITTER_AUTH_HELPER.accounts {
                            if twitterHandle == account.username {
                                
                                // Authenticate the Twitter user.
                                TWITTER_AUTH_HELPER.authenticateAccount(account as! ACAccount, withCallback: { error, authData in
                                    
                                    if error != nil {
                                        print("Unable to authenticate the selected Twitter account")
                                        self.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
                                    } else {
                                        print("Twitter account successfully logged in")
                                        
                                        // Attempt to create a new user (will just perform required updates if user already exists).
                                        self.createNewUser(authData.uid, provider: authData.provider)
                                        
                                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                                        self.saveUserId(authData.uid)
                                        
                                        // Take the logged in user to the feed screen.
                                        self.goToFeedVC()
                                    }
                                    
                                })
                            }
                        }
                    })
                    actionSheetController.addAction(twitterAccountAction)
                }
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        })
    }
    // Twitter login end.
    
    
    
    // Google login.
    @IBAction func googleBtnTapped(sender: UIButton!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Implement the required GIDSignInDelegate methods (Google).
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            // Auth with Firebase
            DataService.ds.REF_BASE.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { error, authData in
                print("Google account successfully logged in")
                
                // Attempt to create a new user (will just perform required updates if user already exists).
                self.createNewUser(authData.uid, provider: authData.provider)
                
                // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                self.saveUserId(authData.uid)
                
                // Take the logged in user to the feed screen.
                self.goToFeedVC()
            })
        } else {
            displayOkAlert("Error", message: error.localizedDescription)
            print("Google sign in error\(error.localizedDescription)")
        }
    }
    
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        //        DataService.ds.REF_BASE.unauth()
        logOut()
    }
    // Google login end.
    
    
    
    // Email login. // REFACTOR ONCE NEW EMAIL LOGIN WORKFLOW IS CREATED.
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            
                            if error != nil { // INCLUDE ALL SCENARIOS.
                                self.displayOkAlert("Could Not Create Account", message: "Problem creating the account. Try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (err, authData) in
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                            
                        })
                    } else {
                        self.displayOkAlert("Could Not Log In", message: "Please check your username and password.")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        } else {
            displayOkAlert("Email and Password Required", message: "You must enter an email and password.")
        }
    }
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
        performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    }
    
    // Log out the user.
    func logOut() {
        // Sign out of Google.
        GIDSignIn.sharedInstance().signOut()
        // Unauthenticate the user.
        DataService.ds.REF_USER_CURRENT.unauth()
        // Clear the saved UID in the user defaults.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
    }
    
}

