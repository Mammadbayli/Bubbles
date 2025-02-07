//
//  Buddy+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Buddy+CoreDataProperties.h"

@implementation Buddy (CoreDataProperties)

+ (NSFetchRequest<Buddy *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Buddy"];
}

@dynamic username;
@dynamic sectionTitle;
@dynamic name;
@dynamic surname;
@dynamic isInRoster;
@dynamic attributes;
@dynamic photos;

@end
