//
//  TwitterAuthHelper.h
//  Login Demo
//
//  Created by Katherine Fang on 9/30/14.
//  Updated by Jess Rascal on 5/19/16 (for Firebase SDK v3).
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <Accounts/Accounts.h>
//#import <Firebase/Firebase.h>
@import Firebase;

@interface TwitterAuthHelper : NSObject

@property (strong, nonatomic) ACAccountStore *store;
//@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSArray *accounts;

//- (id) initWithFirebaseRef:(Firebase *)ref apiKey:(NSString *)apiKey;
- (id) initWithFirebaseRef:(FIRDatabaseReference *)ref apiKey:(NSString *)apiKey;

// Step 1a
- (void) selectTwitterAccountWithCallback:(void (^)(NSError *error, NSArray *accounts))callback;

// Step 1b through 3:
//- (void) authenticateAccount:(ACAccount *)account withCallback:(void (^)(NSError *error, FAuthData *authData))callback;
- (void) authenticateAccount:(ACAccount *)account withCallback:(void (^)(NSError *error, FIRUser *user))callback;

@end

typedef NS_ENUM(NSInteger, AuthHelperError) {
    AuthHelperErrorAccountAccessDenied = -1,
    AuthHelperErrorOAuthTokenRequestDenied = -2
};