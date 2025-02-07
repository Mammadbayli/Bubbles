//
//  RosterController+XMPPRosterDelegate.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/17/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "RosterController.h"

@import XMPPFramework;

NS_ASSUME_NONNULL_BEGIN

@interface RosterController (XMPPRosterDelegate)<XMPPRosterDelegate, XMPPRosterMemoryStorageDelegate>

@end

NS_ASSUME_NONNULL_END
