//
//  BuddySelector.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/20/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface BuddySelector : NSObject
+ (instancetype)sharedInstance;
- (AnyPromise *)selectWithMultipleOption:(BOOL)shouldSelectMultiple;
@end

NS_ASSUME_NONNULL_END
