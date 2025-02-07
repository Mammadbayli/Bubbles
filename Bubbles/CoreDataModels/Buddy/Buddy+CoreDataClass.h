//
//  Buddy+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserPhoto+CoreDataClass.h"
@import UIKit;
@import PromiseKit;

@class UserAttribute;


@interface Buddy : NSManagedObject
+ (instancetype)buddyWithUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;
- (void)fetchVCard;
@end

#import "Buddy+CoreDataProperties.h"
