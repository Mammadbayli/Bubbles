//
//  File+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 11.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//
//

#import "File+CoreDataClass.h"
#import "Message+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface File (CoreDataProperties)

+ (NSFetchRequest<File *> *)fetchRequest;

@property (nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) Message *message;

@end

NS_ASSUME_NONNULL_END
