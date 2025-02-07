//
//  ChatRoomCategory+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/1/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoomCategory+CoreDataClass.h"
#import "ChatRoom+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomCategory (CoreDataProperties)

+ (NSFetchRequest<ChatRoomCategory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *categoryId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSURL *icon;
@property (nonatomic) int16_t unreadCount;
@property (nullable, nonatomic, retain) NSOrderedSet<ChatRoom *> *rooms;
@end

@interface ChatRoomCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(ChatRoom *)value inGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRoomsAtIndex:(NSUInteger)idx;
- (void)insertRooms:(NSArray<ChatRoom *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRoomsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRoomsAtIndex:(NSUInteger)idx withObject:(ChatRoom *)value;
- (void)replaceRoomsAtIndexes:(NSIndexSet *)indexes withGroups:(NSArray<ChatRoom *> *)values;
- (void)addRoomsObject:(ChatRoom *)value;
- (void)removeRoomsObject:(ChatRoom *)value;
- (void)addRooms:(NSOrderedSet<ChatRoom *> *)values;
- (void)removeRooms:(NSOrderedSet<ChatRoom *> *)values;

@end

NS_ASSUME_NONNULL_END
