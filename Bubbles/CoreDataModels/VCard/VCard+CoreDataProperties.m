//
//  VCard+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "VCard+CoreDataProperties.h"

@implementation VCard (CoreDataProperties)

+ (NSFetchRequest<VCard *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VCard"];
}

@dynamic username;
@dynamic fields;
@dynamic photos;
@end
