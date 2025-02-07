//
//  UserAttribute+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserAttribute+CoreDataClass.h"
#import "NSString+JSONParsing.h"
#import "XMPPController.h"
#import "ProfileController.h"

@implementation UserAttribute

- (NSString *)string {
    return [NSString stringWithFormat:@"{\"value\":\"%@\", \"visible\":%@}", [self value] ? [self value] : @"", [self isVisible] ? @"true" : @"false"];
}

- (NSDictionary *)json {
    return @{@"value":[self value] ? [self value] : @"", @"visible":[NSNumber numberWithBool:[self isVisible]]};
}

- (void)parseValues:(NSDictionary *)values {
    @try {
        if(self) {
            if ([values respondsToSelector:@selector(objectForKey:)]) {
                NSString *value = [values objectForKey:@"value"];
                id visible = [values objectForKey:@"visible"];
                BOOL isVisible;
                
                if ([visible respondsToSelector:@selector(isEqualToString:)]) {
                    isVisible = [NSString stringToBool:visible];
                } else {
                    NSNumber* boolean = [values valueForKey:@"visible"];
                    isVisible = [boolean boolValue];
                }
                
                if(![[self value] isEqualToString:value]) {
                    [self setValue:value];
                }
                
                if([self isVisible] != isVisible) {
                    [self setIsVisible:isVisible];
                }
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
