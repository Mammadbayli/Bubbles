//
//  BuddyRequest+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/18/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "BuddyRequest+CoreDataProperties.h"

@implementation BuddyRequest (CoreDataProperties)

+ (NSFetchRequest<BuddyRequest *> *)createFetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"BuddyRequest"];
}

@dynamic username;

@end
