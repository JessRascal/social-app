//
//  AppDelegate.swift
//  justonejess-social
//
//  Created by Jess Rascal on 25/04/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Material
import Firebase
import Fabric
import TwitterKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        // Integrate Fabric (for Twitter auth).
        Fabric.with([Twitter.self])
        
        // Set the initial view controller (depends on if the user has a uid saved in their userDefaults).
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialVC: String!
        
        // Determine the initial view controller.
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            // Set the initial VC to the FeedVC.
            initialVC = "FeedVC"
        } else {
            // Set the initial VC to the SignInVC.
            initialVC = "AuthVC"
        }
        
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initialVC)
        let sideViewController = storyboard.instantiateViewControllerWithIdentifier(SIDE_NAV_VC) as! SideNavVC
        self.window?.rootViewController = SideNavigationController(rootViewController: initialViewController, leftViewController: sideViewController)
        self.window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        let key = NSBundle.mainBundle().objectForInfoDictionaryKey("consumerKey"),
        secret = NSBundle.mainBundle().objectForInfoDictionaryKey("consumerSecret")
        if let key = key as? String, secret = secret as? String
            where key.characters.count > 0 && secret.characters.count > 0 {
            Twitter.sharedInstance().startWithConsumerKey(key, consumerSecret: secret)
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String : AnyObject])
        -> Bool {
            return self.application(application,
                                    openURL: url,
                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String?,
                                    annotation: [:])
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if GIDSignIn.sharedInstance().handleURL(url,
                                                sourceApplication: sourceApplication,
                                                annotation: annotation) {
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }
    
    //    func application(application: UIApplication,
    //                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
    //        return GIDSignIn.sharedInstance().handleURL(url,
    //                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
    //                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    //    }
    
}

