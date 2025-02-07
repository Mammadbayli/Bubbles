//
//  Post+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Post+CoreDataClass.h"
#import "Comment+CoreDataClass.h"
#import "ChatRoom+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN
@class Comment;

@interface Post (CoreDataProperties)

+ (NSFetchRequest<Post *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) ChatRoom *room;
@property (nonatomic) int16_t unreadCount;
@property (nonatomic, retain) NSOrderedSet<Comment *> *comments;

@end

@interface Post (CoreDataGeneratedAccessors)

- (void)insertObject:(Comment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray<Comment *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(Comment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray<Comment *> *)values;
- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSOrderedSet<Comment *> *)values;
- (void)removeComments:(NSOrderedSet<Comment *> *)values;

@end
NS_ASSUME_NONNULL_END
