//
//  XMPPController+Authentication.h
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMPPController (Authentication)
- (void)authenticate;
- (void)authenticateWithUsername:(NSString*)username andPassword:(NSString *)password;
- (void)clearAuthenticationData;
@end

NS_ASSUME_NONNULL_END
