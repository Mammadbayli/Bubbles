//
//  XMPPControllerRegistrationDelegate.h
//  Bubbles
//
//  Created by Javad on 08.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XMPPControllerRegistrationDelegate <NSObject>
@optional
- (void)didRegister;
@end

NS_ASSUME_NONNULL_END
