//
//  NSString+JSONParsing.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JSONParsing)
- (NSDictionary*)json;
+ (NSString*)boolToString: (BOOL)value;
+ (BOOL)stringToBool: (NSString*)value;
@end

NS_ASSUME_NONNULL_END
