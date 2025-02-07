//
//  RemoteNotificationsController.m
//  Bubbles
//
//  Created by Javad Mammadbeyli on 709//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "RemoteNotificationsController.h"
#import "Constants.h"
#import "PersistencyManager.h"
#import "APIRequest.h"
#import "NSURLSession+CertificatePinning.h"

@import Firebase;

@implementation RemoteNotificationsController
+ (instancetype)sharedInstance {
    static RemoteNotificationsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)currentToken {
    return [[FIRMessaging messaging] FCMToken];
}

- (BOOL)isPushNotificationEnabled {
    return [[PersistencyManager sharedInstance] isNotificaionsEnabled];
}

- (void)setIsPushNotificationEnabled:(BOOL)isPushNotificationEnabled {
    [[PersistencyManager sharedInstance] setNotificaionsEnabled:isPushNotificationEnabled];
}

- (AnyPromise *)enablePushNotifications {
    if (![self currentToken]) {
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
            [[NSNotificationCenter defaultCenter] addObserverForName:@"FCMToken"
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:^(NSNotification * _Nonnull notification) {
                NSString *token = [[notification userInfo] objectForKey:@"token"];
                if (token) {
                    resolve(token);
                } else {
                    resolve([NSError errorWithDomain:@"push" code:-1 userInfo:nil]);
                }
            }];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }].then(^(NSString *token) {
            return [self sendTokenToBackend:token].then(^{
                [self setIsPushNotificationEnabled:YES];
            });
        });
    }
    
    return [self sendSavedTokenToBackend].then(^{
        [self setIsPushNotificationEnabled:YES];
    });
}

- (AnyPromise *)sendSavedTokenToBackend {
    if ([self currentToken]) {
        return [self sendTokenToBackend:[self currentToken]];
    }
    
    return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"push" code:-1 userInfo:nil]];
}

- (AnyPromise *)sendTokenToBackend:(NSString *)token {
    NSString *userId = [[PersistencyManager sharedInstance] getUsername];
    NSDictionary *body = @{@"user_id": userId, @"token": token, @"platform": @"iOS"};
    NSString *path = @"token";
    
    return [self postToBackendWithPath:path andBody:body];
}

- (AnyPromise *)saveToken:(NSString *)token {
    if (!token) {
        return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"push" code:-1 userInfo:nil]];
    }
    
    if (![[self currentToken] isEqualToString:token]) {
        [self deleteTokenFromBackend:[self currentToken]];
        
        if ([self isPushNotificationEnabled]) {
            return [self sendTokenToBackend:token];
        }
    }
    
    return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"push" code:-1 userInfo:nil]];
}

- (AnyPromise *)postToBackendWithPath:(NSString *)path andBody:(NSDictionary *)body {
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:path andData:body];
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request];
}

- (AnyPromise *)disablePushNotifications {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    return [self deleteSavedToken].then(^{
        [self setIsPushNotificationEnabled:NO];
    });
}

- (AnyPromise *)deleteTokenFromBackend:(NSString *)token {
    NSString *userId = [[PersistencyManager sharedInstance] getUsername];
    if (!userId || !token) {
        return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"push" code:-1 userInfo:nil]];
    }
    
    NSDictionary *body = @{@"user_id": userId, @"token": token, @"platform": @"iOS"};
    NSString *path = @"token";
    
    NSMutableURLRequest *request = [APIRequest DELETERequestWithPath:path andData:body];
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request];
}

- (AnyPromise *)deleteSavedToken {
    NSString *previouslySavedToken = [self currentToken];
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [[FIRMessaging messaging] deleteTokenWithCompletion:^(NSError * _Nullable error) {
            resolve(error);
        }];
    }].then(^() {
        return [self deleteTokenFromBackend:previouslySavedToken];
    });
}

- (AnyPromise *)saveSoundPreference:(NSString *)soundId {
    if (soundId) {
        [[PersistencyManager sharedInstance] saveNotificationSoundId:soundId];
        return [self sendSoundPreferenceToBackend:soundId];
    }
    
    return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"sound" code:-1 userInfo:nil]];
}

- (NSString *)getSoundPreference {
    return [[PersistencyManager sharedInstance] getNotificationSoundId];
}

- (AnyPromise *)sendSoundPreferenceToBackend:(NSString *)soundId {
    NSString *userId = [[PersistencyManager sharedInstance] getUsername];
    NSDictionary *body = @{@"user_id": userId, @"sound_id": soundId};
    NSString *path = @"notification-preference";
    
    return [self postToBackendWithPath:path andBody:body];
}

@end
