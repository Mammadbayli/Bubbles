//
//  NSString+Comparison.m
//  Bubbles
//
//  Created by Javad on 04.04.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "NSString+Comparison.h"

@implementation NSString (Comparison)
- (NSComparisonResult)compareStringInReverseWithString:(NSString *)secondString {
    NSComparisonResult result = NSOrderedSame;
    
    if ([secondString length] == [self length]) {
        NSUInteger i = [self length] - 1;
        
        while (i >= 0) {
            unichar firstChar = [self characterAtIndex:i];
            unichar secondChar = [secondString characterAtIndex:i];
            
            if ((firstChar - secondChar) < 0) {
                result = NSOrderedDescending;
                break;
            } else if ((firstChar - secondChar) > 0) {
                result = NSOrderedAscending;
                break;
            }
            
            i -= 1;
        }
    }
    
    return result;
}

- (NSUInteger)dateValue {
    NSArray *parts = [self componentsSeparatedByString: @"."];
    
    NSUInteger sum = [parts[0] integerValue] + [parts[1] integerValue]*30 + [parts[2] integerValue]*365;
    
    return sum;
}

- (NSComparisonResult)compareStringsAsDates:(NSString *)secondString {
    NSComparisonResult result = NSOrderedSame;
    
    if ([self dateValue] > [secondString dateValue]) {
        result = NSOrderedDescending;
    } else if ([self dateValue] < [secondString dateValue]) {
        result = NSOrderedAscending;
    }
    
    return result;
}
@end
