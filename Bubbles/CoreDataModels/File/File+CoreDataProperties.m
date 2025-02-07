//
//  File+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//
//

#import "File+CoreDataProperties.h"

@implementation File (CoreDataProperties)

+ (NSFetchRequest<File *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"File"];
}

@dynamic name;
@dynamic type;
@dynamic message;

@end
