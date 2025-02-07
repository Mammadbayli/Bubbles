//
//  ChatRoomCategory+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/1/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomCategory : NSManagedObject
+ (instancetype)categoryWithObject:(NSDictionary*)object usingContext:(NSManagedObjectContext*)context;
+ (instancetype)categoryWithCategoryId:(NSString *)categoryId usingContext:(NSManagedObjectContext *)context;
- (void)parseObject:(NSDictionary*)object;
@end

NS_ASSUME_NONNULL_END

#import "ChatRoomCategory+CoreDataProperties.h"
