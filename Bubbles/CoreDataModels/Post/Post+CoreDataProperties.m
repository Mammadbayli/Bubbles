//
//  Post+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Post+CoreDataProperties.h"

@implementation Post (CoreDataProperties)

+ (NSFetchRequest<Post *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Post"];
}

@dynamic title;
@dynamic comments;
@dynamic room;
@dynamic unreadCount;

@end
