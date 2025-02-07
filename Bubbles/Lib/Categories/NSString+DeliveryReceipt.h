//
//  NSString+DeliveryReceipt.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 10/19/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DeliveryReceipt)
- (NSAttributedString *)getDeliveryReceiptAttributedString;
+ (NSString *)convertSecondsToHumanReadableString:(int)seconds;
@end

NS_ASSUME_NONNULL_END
