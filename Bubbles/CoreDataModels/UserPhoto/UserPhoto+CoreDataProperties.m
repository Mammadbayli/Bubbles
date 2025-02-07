//
//  UserPhoto+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/12/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserPhoto+CoreDataProperties.h"

@implementation UserPhoto (CoreDataProperties)

+ (NSFetchRequest<UserPhoto *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserPhoto"];
}

@dynamic name;
@dynamic username;
@dynamic index;
@dynamic owner;

@end
