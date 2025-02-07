//
//  UserPhoto+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/12/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserPhoto+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserPhoto (CoreDataProperties)

+ (NSFetchRequest<UserPhoto *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *username;
@property (nonatomic) int16_t index;
@property (nullable, nonatomic, retain) Buddy *owner;

@end

NS_ASSUME_NONNULL_END
