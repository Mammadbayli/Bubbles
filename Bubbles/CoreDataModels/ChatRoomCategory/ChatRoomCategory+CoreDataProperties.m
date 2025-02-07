//
//  ChatRoomCategory+CoreDataProperties.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/1/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoomCategory+CoreDataProperties.h"

@implementation ChatRoomCategory (CoreDataProperties)

+ (NSFetchRequest<ChatRoomCategory *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChatRoomCategory"];
}

@dynamic categoryId;
@dynamic name;
@dynamic icon;
@dynamic unreadCount;
@dynamic rooms;
@end
