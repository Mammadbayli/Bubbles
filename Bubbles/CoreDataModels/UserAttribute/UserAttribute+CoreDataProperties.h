//
//  UserAttribute+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserAttribute+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserAttribute (CoreDataProperties)
+ (NSFetchRequest<UserAttribute *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *value;
@property (nonatomic) BOOL isVisible;
@property (nullable, nonatomic, retain) Buddy *owner;

@end

NS_ASSUME_NONNULL_END
