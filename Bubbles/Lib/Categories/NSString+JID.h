//
//  NSString+JID.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/26/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import XMPPFramework;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JID)
- (XMPPJID *)jid;
- (XMPPJID *)groupJid;
@end

NS_ASSUME_NONNULL_END
