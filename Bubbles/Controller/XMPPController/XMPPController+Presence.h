//
//  XMPPController+Presence.h
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMPPController (Presence)
- (void)sendPresence;
- (void)goOffline;
- (void)goOnline;
- (void)setPresence:(NSString *)value;
- (void)sendLastActivityQueryToUser:(NSString*)username;
@end

NS_ASSUME_NONNULL_END
