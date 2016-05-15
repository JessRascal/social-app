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

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Attempt to sign in silently, this will succeed if
        // the user has recently been authenticated.
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    // Facebook login.
    @IBAction func fbBtnTapped(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: { facebookResult, facebookError -> Void in
            if facebookError != nil {
                print("Facebook login failed - \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Facebook login failed. \(error)")
                    } else {
                        print("Facebook account successfully logged in")
                        
                        // Create a new user if the user doesn't already exist.
                        self.createNewUser(authData.uid, provider: authData.provider)
                            
                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                        self.saveUserId(authData.uid)
                        
                        // Take the logged in user to the main screen.
                        self.goToMainScreen()
                    }
                })
            }
            })
    }
    
    // Twitter Login
    @IBAction func twitterBtnTapped(sender: UIButton!) {
        
        TWITTER_AUTH_HELPER.selectTwitterAccountWithCallback({ error, accounts in
            
            if error != nil {
                print("Unable to retrieve the Twitter accounts")
                self.displayOkAlert("Error", message: error.localizedDescription, style: .Alert)
            } else if accounts.count == 1 {
                
                // Get the Twitter account.
                let account = accounts[0] as? ACAccount
                
                // Authenticate the Twitter user.
                TWITTER_AUTH_HELPER.authenticateAccount(account, withCallback: { error, authData in
                    
                    if error != nil {
                        print("Unable to authenticate the selected Twitter account")
                        self.displayOkAlert("Error", message: error.localizedDescription, style: .Alert)
                    } else {
                        print("Twitter account successfully logged in")
                        
                        // Create a new user if the user doesn't already exist.
                        self.createNewUser(authData.uid, provider: authData.provider)
                        
                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                        self.saveUserId(authData.uid)
                        
                        // Take the logged in user to the main screen.
                        self.goToMainScreen()
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
                                        self.displayOkAlert("Error", message: error.localizedDescription, style: .Alert)
                                    } else {
                                        print("Twitter account successfully logged in")
                                        
                                        // Create a new user if the user doesn't already exist.
                                        self.createNewUser(authData.uid, provider: authData.provider)
                                        
                                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                                        self.saveUserId(authData.uid)
                                        
                                        // Take the logged in user to the main screen.
                                        self.goToMainScreen()
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
                
                // Create a new user if the user doesn't already exist.
                self.createNewUser(authData.uid, provider: authData.provider)
                
                // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                self.saveUserId(authData.uid)
                
                // Take the logged in user to the main screen.
                self.goToMainScreen()
            })
        } else {
            displayOkAlert("Error", message: error.localizedDescription, style: .Alert)
        }
    }
    
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        DataService.ds.REF_BASE.unauth()
    }
    
    func createNewUser(uid: String, provider: String) {
        let userData = ["provider": provider]
        DataService.ds.createFirebaseUser(uid, user: userData)
    }
    
    func saveUserId(uid: String) {
        NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
    }
    
    func goToMainScreen() {
        performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    }
    
    func displayOkAlert(title: String, message: String, style: UIAlertControllerStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func logOut() {
        // Sign out of Google.
        GIDSignIn.sharedInstance().signOut()
        // Unauthenticate the user.
        DataService.ds.REF_USER_CURRENT.unauth()
        // Clear the saved UID in the user defaults.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
    }
    
    // Email login. // REFACTOR ONCE NEW EMAIL LOGIN WORKFLOW IS CREATED.
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            
                            if error != nil {
                                self.showErrorAlert("Could Not Create Account", msg: "Problem creating the account. Try something else")
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
                        self.showErrorAlert("Could Not Log In", msg: "Please check your username and password.")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and password.")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

