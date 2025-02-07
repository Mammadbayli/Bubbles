//
//  LoggerController.h
//  Bubbles
//
//  Created by Javad on 24.08.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoggerController : NSObject

+ (instancetype)sharedInstance;

- (void)log:(NSString *)message;
- (void)logError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
