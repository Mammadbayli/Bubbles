//
//  CoreDataStack.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/19/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStack : NSObject
@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *childContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *backgroundContext;
+ (instancetype)sharedInstance;
- (AnyPromise *)saveContext:(NSManagedObjectContext *)context;
- (void)saveContextThreadUnsafe:(NSManagedObjectContext *)context error:(NSError **)error;
- (AnyPromise *)deleteObject:(NSManagedObject *)object usingContext:(NSManagedObjectContext *)context;
- (void)destroyAllData;
- (AnyPromise *)updateUsername:(NSString *)username;
- (AnyPromise *)resetChatRoomSubscritions;
@end

NS_ASSUME_NONNULL_END
