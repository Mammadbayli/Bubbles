//
//  RemoteNotificationsController.h
//  Bubbles
//
//  Created by Javad Mammadbeyli on 709//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface RemoteNotificationsController : NSObject<FIRMessagingDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)sharedInstance;
- (AnyPromise *)saveToken:(NSString *)token;
- (AnyPromise *)saveSoundPreference:(NSString *)soundId;
- (NSString *)getSoundPreference;
- (AnyPromise *)disablePushNotifications;
- (AnyPromise *)enablePushNotifications;

@property BOOL isPushNotificationEnabled;

@end

NS_ASSUME_NONNULL_END
