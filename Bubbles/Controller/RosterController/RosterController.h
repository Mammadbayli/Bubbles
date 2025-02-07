//
//  RosterController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/17/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

@import XMPPFramework;
@import PromiseKit;
#import "BuddyRequest+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RosterController : NSObject

@property (atomic, readonly) BOOL isFetchingRoster;

+ (instancetype)sharedInstance;
- (AnyPromise *)sendFriendRequestToUser:(NSString*)username;
- (AnyPromise *)declineBuddyRequest: (BuddyRequest*)buddyRequest;
- (AnyPromise *)acceptBuddyRequest:(BuddyRequest*)buddyRequest;
- (AnyPromise *)removeBuddyFromRoster:(NSString *)username;
- (void)addBuddyRequest:(NSString*)username;
- (void)addBuddyToRosterWithUsername:(NSString *)username;
- (NSFetchedResultsController *)rosterFetchedResultsController;
- (AnyPromise *)fetchRoster;
- (AnyPromise *)deleteRosterItem:(NSString *)rosterItem;

@end

NS_ASSUME_NONNULL_END
