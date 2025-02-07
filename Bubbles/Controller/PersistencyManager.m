//
//  PersistencyManager.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/16/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "PersistencyManager.h"
#import "CoreDataStack.h"
#import "NSString+FilePath.h"
#import "APIRequest.h"
#import "NSString+Random.h"
#import "Constants.h"
#import "NSURLSession+CertificatePinning.h"
#import "NSData+Compression.h"

@implementation PersistencyManager
+ (id)sharedInstance {
    static PersistencyManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)saveLanguagePreference: (NSString*)preference {
    [[NSUserDefaults standardUserDefaults] setObject:preference forKey:@"lang_pref"];
}

- (NSString *)getLanguagePrefence {
    NSString* pref = [[NSUserDefaults standardUserDefaults] stringForKey:@"lang_pref"];
    return pref ? pref : [[[NSBundle mainBundle] preferredLocalizations] firstObject];
}

- (void)saveUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:[username lowercaseString] forKey:@"username"];
}

- (NSString *)getUsername {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
}

- (void)savePassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

- (NSString *)getPassword {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
}

- (void)saveRequestId:(NSString *)requestId {
    [[NSUserDefaults standardUserDefaults] setObject:requestId forKey:@"request_id"];
}

- (NSString *)getRequestId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"request_id"];
}

- (void)saveUsernameChangeRequestId:(NSString *)requestId {
    [[NSUserDefaults standardUserDefaults] setObject:requestId forKey:@"username_change_request_id"];
}

- (NSString *)getUsernameChangeRequestId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"username_change_request_id"];
}

- (BOOL)isRegistered {
    return [self getPassword] && [self getUsername];
}

- (void)setNotificaionsEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"notif_enabled"];
}

- (BOOL)isNotificaionsEnabled {
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if(![[[defaults dictionaryRepresentation] allKeys] containsObject:@"notif_enabled"]){
        return YES;
    }
    return [defaults boolForKey:@"notif_enabled"];
}

- (void)saveNotificationSoundId:(NSString *)soundId {
    [[NSUserDefaults standardUserDefaults] setObject:soundId forKey:@"notif_sound_id"];
}

- (NSString *)getNotificationSoundId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"notif_sound_id"];
}

- (NSString *)getFCMToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"fcm_token"];
}

- (void)saveFCMToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"fcm_token"];
}

- (void)clearUsernameAndPassword {
    [[PersistencyManager sharedInstance] saveUsername:nil];
    [[PersistencyManager sharedInstance] savePassword:nil];
}

- (void)destroyAllData {
    [[CoreDataStack sharedInstance] destroyAllData];
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults dictionaryRepresentation];
    for (NSString *key in [dict allKeys]) {
        [defaults removeObjectForKey:key];
    }
                          
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:NSBundle.mainBundle.bundleIdentifier];
}

- (AnyPromise *)fileWithName:(NSString *)fileName {
    if (!fileName) {
        return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"alert" code:-1 userInfo:nil]];
    }
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *localFilePath = [fileName localFilePath];
            NSData *localFile = [NSData dataWithContentsOfFile:localFilePath];
            
            if (localFile) {
                resolve(localFile);
                return;
            }
            
            NSString *urlString = [NSString stringWithFormat:@"document/%@", fileName];
            APIRequest *request = [APIRequest GETRequestWithPath:urlString];
            
            NSURLSession *defaultSession = [NSURLSession certificatePinnedSession];
            NSURLSessionDataTask *task = [defaultSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    resolve([NSError errorWithDomain:@"alert" code:-1 userInfo:nil]);
                } else {
                    [data writeToFile:localFilePath options:NSDataWritingAtomic error:nil];
                    resolve(data);
                }
            }];
            
            [task resume];
        });
    }];
}

- (AnyPromise *)uploadFile:(NSData *)data withName:(NSString *)fileName {
    if (!fileName) {
        fileName = [NSString randomFilename];
    }
    
    [data writeToFile:[fileName localFilePath]
              options:NSDataWritingAtomic
                error:nil];
    
    data = [data compress];
    
    NSString *urlString = [NSString stringWithFormat:@"document/%@", fileName];
    APIRequest *request = [APIRequest PUTRequestWithPath:urlString];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request].then(^(){
        return [AnyPromise promiseWithValue:fileName];
    });
}

- (AnyPromise *)uploadFile:(NSData *)data {
    return [self uploadFile:data withName:nil];
}

@end
