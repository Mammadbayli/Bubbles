//
//  BuddyRequest+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/18/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "BuddyRequest+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BuddyRequest (CoreDataProperties)

+ (NSFetchRequest<BuddyRequest *> *)createFetchRequest;

@property (nullable, nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
