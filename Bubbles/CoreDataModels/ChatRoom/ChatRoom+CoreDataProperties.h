//
//  ChatRoom+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoom+CoreDataClass.h"
#import "ChatRoomCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class Post, ChatRoomCategory;
@interface ChatRoom (CoreDataProperties)

+ (NSFetchRequest<ChatRoom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *roomId;
@property (nullable, nonatomic, copy) NSURL *icon;
@property (nonatomic) BOOL isSubscribed;
@property (nonatomic) int16_t unreadCount;
@property (nullable, nonatomic, retain) NSOrderedSet<Post *> *posts;
@property (nullable, nonatomic, retain) ChatRoomCategory *category;
@end

@interface ChatRoom (CoreDataGeneratedAccessors)

- (void)insertObject:(Post *)value inPostsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPostsAtIndex:(NSUInteger)idx;
- (void)insertPosts:(NSArray<Post *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePostsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPostsAtIndex:(NSUInteger)idx withObject:(Post *)value;
- (void)replacePostsAtIndexes:(NSIndexSet *)indexes withPosts:(NSArray<Post *> *)values;
- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSOrderedSet<Post *> *)values;
- (void)removePosts:(NSOrderedSet<Post *> *)values;

@end

NS_ASSUME_NONNULL_END
