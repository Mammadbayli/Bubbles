//
//  Message+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/9/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Message+CoreDataClass.h"
#import "File+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
//@property (nullable, nonatomic, copy) NSString *remoteFile;
@property (nullable, nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic) BOOL isStarred;
@property (nonatomic) BOOL isUnread;
@property (nonatomic, copy) NSString *uniqueId;
@property (nullable, nonatomic, retain) NSOrderedSet<File *> *files;

@end

@interface Message (CoreDataGeneratedAccessors)

- (void)insertObject:(File *)value inFilesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFilesAtIndex:(NSUInteger)idx;
- (void)insertFiles:(NSArray<File *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFilesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFilesAtIndex:(NSUInteger)idx withObject:(File *)value;
- (void)replaceFilesAtIndexes:(NSIndexSet *)indexes withFiles:(NSArray<File *> *)values;
- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSOrderedSet<File *> *)values;
- (void)removeFiles:(NSOrderedSet<File *> *)values;

@end

NS_ASSUME_NONNULL_END
