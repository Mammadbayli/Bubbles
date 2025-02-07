//
//  RegistrationController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "RegistrationController.h"
#import "AppDelegate.h"
#import "ActivityIndicatorPresenter.h"
#import "Constants.h"
#import "NSString+Random.h"
#import "AlertPresenter.h"
#import "PersistencyManager.h"
#import "NSError+PromiseKit.h"
#import "XMPPController.h"
#import "RemoteNotificationsController.h"
#import "APIRequest.h"
#import "NSURLSession+CertificatePinning.h"
#import "NavigationController.h"
#import "XMPPController+Authentication.h"

@import PromiseKit;
@import FirebaseMessaging;
@import Firebase;

@implementation RegistrationController

-(NSString*)requestId {
    return [[PersistencyManager sharedInstance] getRequestId];
}

+ (id)sharedInstance {
    static RegistrationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (AnyPromise *)resetPassword:(NSString *)userId {
    [[ActivityIndicatorPresenter sharedInstance] present];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userId forKey:@"user_id"];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:@"reset-password" andData:dict];
    
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request].then(^{
        [[AlertPresenter sharedInstance] presentWithTitle:@"success" message:@"password_reset_link_success"];
    })
    .catch(^(NSError *error){
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
        @throw error;
    }).ensure(^() {
        [[ActivityIndicatorPresenter sharedInstance] dismiss];
    });
}

- (void)deleteAccount {
    [[ActivityIndicatorPresenter sharedInstance] present];
    
    [self unregister].then(^{
        [self logOut];
    })
    .catch(^(NSError *error){
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
        @throw error;
    }).ensure(^() {
        [[ActivityIndicatorPresenter sharedInstance] dismiss];
    });
}

- (void)logOut {
    [[ActivityIndicatorPresenter sharedInstance] present];
    
    if ([[[XMPPController sharedInstance] xmppStream] isConnected]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDisconnect)
                                                     name:XMPP_STREAM_DID_DISCONNECT_NOTIFICATION
                                                   object:nil];
        
        [[XMPPController sharedInstance] disconnect];
    } else {
        [self didDisconnect];
    }
}

- (void)didDisconnect {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[RemoteNotificationsController sharedInstance] disablePushNotifications].ensure(^{
        [self setRootWithCompletion:^{
            [[PersistencyManager sharedInstance] destroyAllData];
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        }];
    });
}

- (void)setRootWithCompletion:(void (^)(void))callback {
    dispatch_block_t onMain = ^{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] resetToInitialState];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            callback();
        });
    };
    
    if ([NSThread isMainThread]) {
        onMain();
    } else {
        dispatch_async(dispatch_get_main_queue(), onMain);
    }
}

- (AnyPromise *)unregister {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[PersistencyManager sharedInstance] getUsername] forKey:@"user_id"];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:@"unregister" andData:dict];
    
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request];
}

@end
