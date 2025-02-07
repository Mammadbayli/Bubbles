//
//  UserAttribute+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Buddy;

NS_ASSUME_NONNULL_BEGIN

@interface UserAttribute : NSManagedObject

- (NSString *)string;
- (NSDictionary *)json;
- (void)parseValues:(NSDictionary*)values;

@end

NS_ASSUME_NONNULL_END

#import "UserAttribute+CoreDataProperties.h"
