//
//  RosterController_Private.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/17/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
@import XMPPFramework;

NS_ASSUME_NONNULL_BEGIN

@interface RosterController()
@property (strong, nonatomic, readonly) XMPPRoster *xmppRoster;
@property (strong, nonatomic, readonly) XMPPRosterMemoryStorage *xmppRosterStorage;
@property (strong, nonatomic, readonly) XMPPStream* xmppStream;
@end

NS_ASSUME_NONNULL_END
