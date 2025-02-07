//
//  UserAttribute+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserAttribute+CoreDataProperties.h"

@implementation UserAttribute (CoreDataProperties)

+ (NSFetchRequest<UserAttribute *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserAttribute"];
}

@dynamic name;
@dynamic value;
@dynamic isVisible;
@dynamic username;
@dynamic owner;
@end
