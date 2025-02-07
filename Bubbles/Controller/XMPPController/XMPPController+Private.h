//
//  XMPPController+Private.h
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController.h"
#import "NSString+JID.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMPPController ()

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic, readonly) XMPPLastActivity *xmppLastActivity;

@end

NS_ASSUME_NONNULL_END
