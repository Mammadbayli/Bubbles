//
//  RegistrationController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationController : NSObject
+ (id)sharedInstance;
- (void)deleteAccount;
- (AnyPromise *)resetPassword:(NSString *)userId;
- (void)logOut;
@end

NS_ASSUME_NONNULL_END
