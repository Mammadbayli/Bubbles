//
//  UserSupportController.h
//  Bubbles
//
//  Created by Javad on 08.02.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface UserSupportController : NSObject
+ (instancetype)sharedInstance;
- (AnyPromise *)sendTicket:(NSString *)ticket;
@end

NS_ASSUME_NONNULL_END
