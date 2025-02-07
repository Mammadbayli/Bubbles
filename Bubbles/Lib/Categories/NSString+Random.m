//
//  NSString+Random.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSString+Random.h"

 @implementation NSString (Random)

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }

    return randomString;
}

+ (NSString *)randomFilename {
    return [self randomAlphanumericStringWithLength:16];
}

@end
