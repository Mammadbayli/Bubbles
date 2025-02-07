//
//  ChangeUsernameController.h
//  Bubbles
//
//  Created by Javad on 19.02.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeUsernameController : NSObject
+ (instancetype)sharedInstance;
- (AnyPromise *)requestUsernameChangeToNewUsername:(NSString *)newUsername withSupportingDocuments:(NSArray *)documents;
- (AnyPromise *)getUsernameChangeRequestStatus;
- (AnyPromise *)completeUsernameChange;
@end

NS_ASSUME_NONNULL_END
