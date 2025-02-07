//
//  PersistencyManager.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/16/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

//NS_ASSUME_NONNULL_BEGIN

@interface PersistencyManager : NSObject
+ (instancetype)sharedInstance;
- (void)saveLanguagePreference:(NSString *)preference;
- (NSString *)getLanguagePrefence;
- (void)saveUsername:(NSString* )username;
- (NSString *)getUsername;
- (void)savePassword:(NSString *)password;
- (NSString *)getPassword;
- (void)saveRequestId:(NSString *)requestId;
- (NSString *)getRequestId;
- (void)saveUsernameChangeRequestId:(NSString *)requestId;
- (NSString *)getUsernameChangeRequestId;
- (BOOL)isRegistered;
- (NSString *)getNotificationSoundId;
- (void)saveNotificationSoundId:(NSString *)soundId;
- (BOOL)isNotificaionsEnabled;
- (void)setNotificaionsEnabled:(BOOL)enabled;
- (NSString *)getFCMToken;
- (void)saveFCMToken:(NSString *)token;
- (void)destroyAllData;
- (void)clearUsernameAndPassword;
- (AnyPromise *)fileWithName:(NSString *)fileName;
- (AnyPromise *)uploadFile:(NSData *)data withName:(NSString *)fileName;
- (AnyPromise *)uploadFile:(NSData *)data;
@end

//NS_ASSUME_NONNULL_END
