//
//  Message+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/9/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Message"];
}

@dynamic from;
@dynamic to;
//@dynamic remoteFile;
@dynamic body;
@dynamic timestamp;
@dynamic isStarred;
@dynamic uniqueId;
@dynamic files;
@dynamic isUnread;

@end
