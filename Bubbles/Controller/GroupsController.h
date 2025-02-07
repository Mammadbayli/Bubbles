//
//  GroupsController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/30/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface GroupsController : NSObject
+ (instancetype)sharedInstance;
- (AnyPromise *)loadGroups;
- (void)subscribeToChatRooms;
@end

NS_ASSUME_NONNULL_END
