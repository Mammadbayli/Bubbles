//
//  Buddy+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Buddy+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Buddy (CoreDataProperties)

+ (NSFetchRequest<Buddy *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) BOOL isInRoster;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sectionTitle;
@property (nullable, nonatomic, copy) NSString *surname;
@property (nonatomic, copy) NSString *username;
@property (nullable, nonatomic, retain) NSSet<UserAttribute *> *attributes;
@property (nullable, nonatomic, retain) NSOrderedSet<UserPhoto *> *photos;

@end

@interface Buddy (CoreDataGeneratedAccessors)

- (void)addAttributesObject:(UserAttribute *)value;
- (void)removeAttributesObject:(UserAttribute *)value;
- (void)addAttributes:(NSSet<UserAttribute *> *)values;
- (void)removeAttributes:(NSSet<UserAttribute *> *)values;

- (void)insertObject:(UserPhoto *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray<UserPhoto *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(UserPhoto *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray<UserPhoto *> *)values;
- (void)addPhotosObject:(UserPhoto *)value;
- (void)removePhotosObject:(UserPhoto *)value;
- (void)addPhotos:(NSOrderedSet<UserPhoto *> *)values;
- (void)removePhotos:(NSOrderedSet<UserPhoto *> *)values;

@end

NS_ASSUME_NONNULL_END
