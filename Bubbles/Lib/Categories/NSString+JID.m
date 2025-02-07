//
//  NSString+JID.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/26/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSString+JID.h"
#import "Constants.h"

@implementation NSString (JID)
- (XMPPJID *)jid {
    return [XMPPJID jidWithUser:[self lowercaseString] domain:VIRTUAL_HOST_NAME resource:nil];
}

- (XMPPJID *)groupJid {
    NSString *domain = [NSString stringWithFormat:@"conference.%@", VIRTUAL_HOST_NAME];
    return [XMPPJID jidWithUser:[self lowercaseString] domain:domain resource:nil];
}
@end
