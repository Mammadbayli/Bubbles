//
//  LoggerController.m
//  Bubbles
//
//  Created by Javad on 24.08.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "LoggerController.h"

@import FirebaseCrashlytics;
@import FirebaseAnalytics;

@implementation LoggerController
+ (instancetype)sharedInstance {
    static LoggerController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)log:(NSString *)message {
    [[FIRCrashlytics crashlytics] log:message];
    [FIRAnalytics logEventWithName:@"message"
                        parameters:@{@"value": message}];
    
}

- (void)logError:(NSError *)error {
    [[FIRCrashlytics crashlytics] recordError:error];
    [FIRAnalytics logEventWithName:@"error"
                        parameters:@{@"value": [error localizedDescription]}];
}

@end
