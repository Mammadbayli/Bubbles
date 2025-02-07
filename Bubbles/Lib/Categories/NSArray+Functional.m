//
//  NSArray+Functional.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/16/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)
- (NSArray *)compactMap {
    NSMutableArray *mutableCollection = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != nil) {
            [mutableCollection addObject:obj];
        }
    }];
    return [mutableCollection copy];
}
@end
