//
//  NSString+Comparison.h
//  Bubbles
//
//  Created by Javad on 04.04.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Comparison)

- (NSComparisonResult)compareStringInReverseWithString:(NSString *)secondString;
- (NSComparisonResult)compareStringsAsDates:(NSString *)secondString;

@end

NS_ASSUME_NONNULL_END
