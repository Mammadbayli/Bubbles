//
//  XMPPController+Presence.m
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController+Presence.h"
#import "XMPPController+Private.h"
#import "RosterController.h"

@implementation XMPPController (Presence)

- (void)sendPresence {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    [self setPresence:@"unavailable"];
}

- (void)goOnline {
    [self setPresence:@"available"];
}

- (void)setPresence:(NSString *)value {
    XMPPPresence *presence = [XMPPPresence presenceWithType:value];
    [[self xmppStream] sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type];
    NSString *username = [[presence from] user];
    
    if ([presenceType isEqualToString:@"subscribed"]) {
        [[RosterController sharedInstance] addBuddyToRosterWithUsername:username];
    } else if ([presenceType isEqualToString:@"subscribe"]) {
//        [[RosterController sharedInstance] addBuddyRequest:username];
    } else if ([presenceType isEqualToString:@"unsubscribe"]) {
        [[RosterController sharedInstance] removeBuddyFromRoster:username];
    } else if ([presenceType isEqualToString:@"unavailable"]) {
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:USER_OFFLINE_NOTIFICATION
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": username}]];
        
    } else if ([presenceType isEqualToString:@"available"]) {
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:USER_ONLINE_NOTIFICATION
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": username}]];
    }
}

- (void)sendLastActivityQueryToUser:(NSString*)username {
    XMPPJID *jid = [username jid];
    [[self xmppLastActivity] sendLastActivityQueryToJID:jid];
}

//MARK: XMPPLastActivityDelegate methods
- (void)xmppLastActivity:(XMPPLastActivity *)sender didReceiveResponse:(XMPPIQ *)response {
    NSString *from = [[response from] user];
    if ([[response type] isEqualToString:@"error"]) {
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_ERROR
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": from}]];
    } else {
        NSXMLElement *query = [response childElement];
        NSNumber *seconds = [query attributeNumberIntValueForName:@"seconds"];
        
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:XMPP_STREAM_DID_RECEIVE_LAST_ACTIVITY_RESULT
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": from, @"seconds": seconds}]];
    }
}

- (NSUInteger)numberOfIdleTimeSecondsForXMPPLastActivity:(XMPPLastActivity *)sender queryIQ:(XMPPIQ *)iq currentIdleTimeSeconds:(NSUInteger)idleSeconds {
    return idleSeconds;
}

@end
