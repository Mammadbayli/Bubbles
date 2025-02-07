//
//  ChangeUsernameController.m
//  Bubbles
//
//  Created by Javad on 19.02.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "ChangeUsernameController.h"
#import "APIRequest.h"
#import "ActivityIndicatorPresenter.h"
#import "NSString+Random.h"
#import "PersistencyManager.h"
#import "AlertPresenter.h"
#import "NSError+PromiseKit.h"
#import "CoreDataStack.h"
#import "UserAttribute+CoreDataClass.h"
#import "XMPPController.h"
#import "XMPPController+Authentication.h"
#import "AppDelegate.h"
#import "NSURLSession+CertificatePinning.h"

@interface ChangeUsernameController()
@property (strong, nonatomic) NSString *updatedUsername;
@end

@implementation ChangeUsernameController
+ (instancetype)sharedInstance {
    static ChangeUsernameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (AnyPromise *)requestUsernameChangeToNewUsername:(NSString *)newUsername withSupportingDocuments:(NSArray *)documents {
    [[ActivityIndicatorPresenter sharedInstance] present];
    
    NSMutableArray __block *files = [[NSMutableArray alloc] init];
    NSMutableArray *promises = [[NSMutableArray alloc] init];
    
    for(NSData *document in documents) {
        NSString *remoteFilename = [NSString randomFilename];
        [files addObject:remoteFilename];
        
        NSData *data = UIImageJPEGRepresentation(document, 1);
        
        AnyPromise *promise = [[PersistencyManager sharedInstance] uploadFile:data withName:remoteFilename];
        [promises addObject:promise];
    }
    
    return PMKWhen(promises).then(^{
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             files, @"documents",
                             [[PersistencyManager sharedInstance] getUsername], @"user_id",
                             newUsername, @"new_user_id",
                             nil];
        NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:@"username-change-request" andData:tmp];
        
        return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request];
    }).then(^(id reply){
        NSString *requestId = reply[@"request_id"];
        [[PersistencyManager sharedInstance] saveUsernameChangeRequestId:requestId];
        //        [[AlertPresenter sharedInstance] presentWithTitle:@"Success" message:NSLocalizedString(@"registration_registration_certificate_tip", nil)];
    }).catch(^(NSError *error){
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
        @throw error;
    }).ensure(^() {
        [[ActivityIndicatorPresenter sharedInstance] dismiss];
    });
}

- (AnyPromise *)getUsernameChangeRequestStatus {
    NSString *path = [NSString stringWithFormat:@"username-change-request/%@", [[PersistencyManager sharedInstance] getUsernameChangeRequestId]];
    NSMutableURLRequest *request = [APIRequest GETRequestWithPath:path];
    typeof(self) __weak weakSelf = self;
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request].then(^(id reply) {
        NSInteger isApproved = [[reply valueForKey:@"status"] integerValue];
        NSString *newUsername  = [reply valueForKey:@"new_user_id"];
        [weakSelf setUpdatedUsername:newUsername];
        return [AnyPromise promiseWithValue:[NSNumber numberWithInteger:isApproved]];
    });
}

- (AnyPromise *)completeUsernameChange {
    NSString *path = [NSString stringWithFormat:@"change-username"];
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:path andData:@{@"request_id": [[PersistencyManager sharedInstance] getUsernameChangeRequestId]}];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    [[XMPPController sharedInstance] disconnect];
    
    typeof(self) __weak weakSelf = self;
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request].then(^(id reply) {
        return [[CoreDataStack sharedInstance] updateUsername: [weakSelf updatedUsername]];
    }).then(^(){
        dispatch_block_t onMain = ^{
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if (delegate) {
                [delegate refreshApp];
            }
        };
        
        if ([NSThread isMainThread]) {
            onMain();
        } else {
            dispatch_async(dispatch_get_main_queue(), onMain);
        }
    }).catch(^(NSError *error){
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
        @throw error;
    }).ensure(^() {
        [[XMPPController sharedInstance] authenticate];
        [[ActivityIndicatorPresenter sharedInstance] dismiss];
    });;
}
@end
