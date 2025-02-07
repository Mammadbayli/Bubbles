//
//  VCard+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "VCard+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VCard (CoreDataProperties)

+ (NSFetchRequest<VCard *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic) NSOrderedSet *photos;
@property (nullable, nonatomic) NSOrderedSet *fields;
@end

NS_ASSUME_NONNULL_END
