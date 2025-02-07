//
//  NSString+DeliveryReceipt.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 10/19/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSString+DeliveryReceipt.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"
#import "Constants.h"

@implementation NSString (DeliveryReceipt)
- (NSAttributedString *)getDeliveryReceiptAttributedString {
    NSString *deliveryReceiptString = @"\ue902";
    
    if([self isEqualToString:MESSAGE_STATUS_SENT]) {
        deliveryReceiptString = @"\ue903";
    }
    else if([self isEqualToString:MESSAGE_STATUS_DELIVERED]) {
        deliveryReceiptString = @"\ue903\ue903";
    }
    else if([self isEqualToString:MESSAGE_STATUS_READ]) {
        deliveryReceiptString = @"\ue903\ue903";
    }
    
    NSAttributedString *deliveryReceipt = [[NSAttributedString alloc] initWithString:deliveryReceiptString attributes:@{
        NSFontAttributeName: [[UIFont icomoonFont] fontWithSize:13],
        NSKernAttributeName: @-6.0,
        NSForegroundColorAttributeName: [self isEqualToString:MESSAGE_STATUS_READ] ? [UIColor NFSGreenColor] : [UIColor lightTextColor]
    }];
    
    return deliveryReceipt;
}

+ (NSString *)convertSecondsToHumanReadableString:(int)seconds {
    const int SECONDS_IN_MINUTE = 60;
    const int SECONDS_IN_HOUR = 3600;
    const int SECONDS_IN_DAY = 86400;

    NSString *result;
    
    if (seconds == 0) {
        result = @"last_activity.online";
    } else if(seconds/SECONDS_IN_MINUTE == 0) {
        result = NSLocalizedString(@"last_activity.justNow", nil);
    } else if ((seconds + SECONDS_IN_MINUTE)/SECONDS_IN_HOUR == 0) {
        int minutes = (seconds/SECONDS_IN_MINUTE) + 1;
        result = [NSString stringWithFormat:NSLocalizedString(@"last_activity.online_minutes_ago", nil), minutes];
    } else if((seconds + SECONDS_IN_HOUR)/SECONDS_IN_DAY == 0) {
        int hours = (seconds/SECONDS_IN_HOUR) + 1;
        result = [NSString stringWithFormat:NSLocalizedString(@"last_activity.online_hours_ago", nil), hours];
    } else if ((seconds + SECONDS_IN_HOUR)/SECONDS_IN_DAY == 1) {
        result = NSLocalizedString(@"last_activity.online_yesterday", nil);
    } else {
        NSDate *lastActivityDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-seconds];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.YYYY"];
        
        NSString *exactDateString = [formatter stringFromDate:lastActivityDate];
        result = [NSString stringWithFormat:NSLocalizedString(@"last_activity.online_exact_date", nil), exactDateString];
    }
    
    return result;
}

@end
