//
//  Comment+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Comment+CoreDataProperties.h"

@implementation Comment (CoreDataProperties)

+ (NSFetchRequest<Comment *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
}

@dynamic post;
@end
