//
//  BuddyRequest+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/18/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuddyRequest : NSManagedObject

+ (instancetype)buddyRequestWithUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "BuddyRequest+CoreDataProperties.h"
