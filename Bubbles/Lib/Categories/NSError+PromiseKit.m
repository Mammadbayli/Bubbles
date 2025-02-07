//
//  NSError+PromiseKit.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 5/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSError+PromiseKit.h"

@implementation NSError (PromiseKit)
- (NSString *)message {
    NSData *data = [self userInfo][@"PMKURLErrorFailingDataKey"];
    
    NSString *message;
    
    if (data) {
        NSDictionary *desc = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        message = desc[@"message"];
    } else {
        message = [self localizedDescription];
    }
 
    return message;
}
@end
