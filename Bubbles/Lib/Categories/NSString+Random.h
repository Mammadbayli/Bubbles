//
//  NSString+Random.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)
+(NSString*)randomAlphanumericStringWithLength:(NSInteger)length;
+(NSString*)randomFilename;
@end
