//
//  NSString+JSONParsing.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSString+JSONParsing.h"

@implementation NSString (JSONParsing)
- (NSDictionary *)json {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
           NSError *jsonError;
           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
    
    return json;
}

+ (NSString *)boolToString:(BOOL)value {
    return value ? @"true" : @"false";
}

+ (BOOL)stringToBool:(NSString *)value {
    if([value respondsToSelector:@selector(isEqualToString:)]) {
       return [value isEqualToString:@"true"];
    }
    
    return NO;
}
@end
