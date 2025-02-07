//
//  RosterController+XMPPRosterController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/17/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "RosterController+XMPPRosterDelegate.h"
#import "RosterController_Private.h"
#import "BuddyRequest+CoreDataClass.h"
#import "CoreDataStack.h"
#import "Buddy+CoreDataClass.h"

@implementation RosterController (XMPPRosterDelegate)

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    NSString *presenceType = [presence type]; // online / offline
    //    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    //    NSString *presencefromStr = [presence fromStr];
    
    if  ([presenceType isEqualToString:@"subscribe"]) {
        [self addBuddyRequest:presenceFromUser];
    }
}

@end
