//
//  ChatRoom+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoom+CoreDataProperties.h"

@implementation ChatRoom (CoreDataProperties)

+ (NSFetchRequest<ChatRoom *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChatRoom"];
}

@dynamic name;
@dynamic roomId;
@dynamic icon;
@dynamic isSubscribed;
@dynamic unreadCount;
@dynamic posts;
@dynamic category;
@end
