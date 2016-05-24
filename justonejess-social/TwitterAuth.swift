//
//  TwitterAuth.swift
//  justonejess-social
//
//  Created by Jess Rascal on 18/05/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase

class TwitterAuth {
    
    func authenticate(vc: AuthVC) {
        
        TWITTER_AUTH_HELPER.selectTwitterAccountWithCallback({ error, accounts in
            
            if error != nil {
                print("Unable to retrieve the Twitter accounts")
                vc.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
            } else if accounts.count == 1 {
                
                // Get the Twitter account.
                let account = accounts[0] as? ACAccount
                
                // Authenticate the Twitter user.
                TWITTER_AUTH_HELPER.authenticateAccount(account, withCallback: { error, user in
                    
                    if error != nil {
                        print("Unable to authenticate the selected Twitter account")
                        vc.displayOkAlert("Error", message: error.localizedDescription)
                    } else {
                        print("Twitter account successfully logged in")
                        
                        // Attempt to create a new user (will just perform required updates if user already exists).
//                        vc.createNewUser(authData.uid, provider: authData.provider)
                        vc.createNewUser(user.uid, provider: user.providerID)
                        
                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                        vc.saveUserId(user.uid)
                        
                        // Take the logged in user to the feed screen.
                        vc.goToFeedVC()
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
                                        vc.displayOkAlert("Twitter Login Failed", message: error.localizedDescription)
                                    } else {
                                        print("Twitter account successfully logged in")
                                        
                                        // Attempt to create a new user (will just perform required updates if user already exists).
//                                        vc.createNewUser(authData.uid, provider: authData.provider)
                                        vc.createNewUser(authData.uid, provider: authData.providerID)
                                        
                                        // Store the authData uid to the UserDefaults so it is retained when the app is closed.
                                        vc.saveUserId(authData.uid)
                                        
                                        // Take the logged in user to the feed screen.
                                        vc.goToFeedVC()
                                    }
                                    
                                })
                            }
                        }
                    })
                    actionSheetController.addAction(twitterAccountAction)
                }
                vc.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        })
    }
}
