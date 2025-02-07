//
//  NSURLSession+CertificatePinning.h
//  Bubbles
//
//  Created by Javad on 04.06.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (CertificatePinning)
+ (NSURLSession *)certificatePinnedSession;
@end

NS_ASSUME_NONNULL_END
