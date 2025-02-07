//
//  UserSupportController.m
//  Bubbles
//
//  Created by Javad on 08.02.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "UserSupportController.h"
#import "APIRequest.h"
#import "AlertPresenter.h"
#import "ActivityIndicatorPresenter.h"
#import "PersistencyManager.h"
#import "NSError+PromiseKit.h"
#import "NSURLSession+CertificatePinning.h"

@implementation UserSupportController
+ (instancetype)sharedInstance {
    static UserSupportController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (AnyPromise *)sendTicket:(NSString *)content {
    NSString *username = [[PersistencyManager sharedInstance] getUsername];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         username, @"user_id",
                         content, @"content",
                         nil];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:@"support-ticket" andData:tmp];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request]
    .catch(^(NSError *error){
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
        @throw error;
    }).ensure(^() {
        [[ActivityIndicatorPresenter sharedInstance] dismiss];
    });
}
@end
