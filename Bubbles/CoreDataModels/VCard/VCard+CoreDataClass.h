//
//  VCard+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserAttribute;

NS_ASSUME_NONNULL_BEGIN

@interface VCard : NSManagedObject
+ (instancetype)vCardForUsername:(NSString*)username usingContext:(NSManagedObjectContext*)context;
@end

NS_ASSUME_NONNULL_END

#import "VCard+CoreDataProperties.h"
