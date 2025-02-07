//
//  CoreDataStack.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/19/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "CoreDataStack.h"
#import "LoggerController.h"
#import "Buddy+CoreDataClass.h"
#import "BuddyRequest+CoreDataClass.h"
#import "UserAttribute+CoreDataClass.h"
#import "Message+CoreDataClass.h"
#import "ChatRoom+CoreDataClass.h"
#import "ChatRoomCategory+CoreDataClass.h"
#import "File+CoreDataClass.h"
#import "Bubbles-Swift.h"

@interface CoreDataStack()
@end

@implementation CoreDataStack {
    NSManagedObjectContext *_mainContext;
    NSManagedObjectContext *child;
    NSManagedObjectContext *backgroundContext;
}

- (NSManagedObjectContext*)mainContext {
    if(!_mainContext) {
        _mainContext = [_persistentContainer viewContext];
        [_mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_mainContext setName:@"mainContext"];
        [_mainContext setAutomaticallyMergesChangesFromParent:YES];
        [_mainContext setUndoManager:nil];
    }
    
    return _mainContext;
}

- (NSManagedObjectContext*)childContext {
    NSManagedObjectContext *child = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [child setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [child setUndoManager:nil];
    [child setPersistentStoreCoordinator:[_persistentContainer persistentStoreCoordinator]];
    [child setAutomaticallyMergesChangesFromParent:YES];
    [child setName:@"childContext"];

    return child;
}

- (NSManagedObjectContext*)backgroundContext {
    backgroundContext = [self newBackgroundContext];
    [backgroundContext setName:@"backgroundContext"];
    
    return backgroundContext;
}

- (NSManagedObjectContext*)newBackgroundContext {
    NSManagedObjectContext *context = [_persistentContainer newBackgroundContext];
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [context setUndoManager:nil];
    [context setAutomaticallyMergesChangesFromParent:YES];
    [context setName:@"newBackgroundContext"];
    
    return context;
}

+ (instancetype)sharedInstance {
    static CoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setupCoreDataStack];
    });
    
    return sharedInstance;
}

- (void)setupCoreDataStack {
    _persistentContainer = [NSPersistentContainer persistentContainerWithName:@"Bubbles"];
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
        
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification* note) {
//        
//        NSManagedObjectContext *mainContext = self.mainContext;
//        NSManagedObjectContext *otherMoc = note.object;
//        
//        if (otherMoc.persistentStoreCoordinator == mainContext.persistentStoreCoordinator) {
//            if (otherMoc != mainContext) {
//                [mainContext performBlock:^(){
//                    [mainContext mergeChangesFromContextDidSaveNotification:note];
//                }];
//            }
//        }
//    }];
}

- (AnyPromise *)saveContext:(NSManagedObjectContext *)context {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        __block NSError *error = nil;
        [context performBlock:^{
            [self saveContextThreadUnsafe:context error:&error];
            
            if (error) {
                resolve(error);
            } else {
                resolve(nil);
            }
        }];
    }];
   
}

- (AnyPromise *)deleteObject:(NSManagedObject *)object usingContext:(NSManagedObjectContext *)context {
    if (!object) {
        return [AnyPromise promiseWithValue: [NSError errorWithDomain:@"error" code:-1 userInfo:nil]];
    }
    
    NSString *logMessage = [NSString stringWithFormat:@"Deleting object %@ on context  %@", [object description], [context name]];
    [[LoggerController sharedInstance] log:logMessage];
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [context performBlock:^{
            [context deleteObject:object];
            NSError *error;
            [self saveContextThreadUnsafe:context error:&error];
            
            if (error) {
                resolve(error);
            } else {
                resolve(nil);
            }
        }];
    }];
}

- (void)saveContextThreadUnsafe:(NSManagedObjectContext *)context error:(NSError **)error {
    NSString *contextName = [context name];
    NSString *logMessage = [NSString stringWithFormat:@"Saving context: %@", contextName];
    [[LoggerController sharedInstance] log:logMessage];
    
    NSError *err = nil;
    if([context hasChanges]) {
        BOOL success = [context save:&err];
        
        //Handle validation error
        if (!success && err && [[err domain] isEqualToString:@"NSCocoaErrorDomain"]) {
            [[LoggerController sharedInstance] logError:err];
            [context rollback];
            *error = err;
        }
    }
}

- (void)clearEntity:(NSString *)entityName usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setPredicate:[NSPredicate predicateWithValue:YES]];
    [request setIncludesPropertyValues:NO];
    
    NSArray* items = [context executeFetchRequest:request error:nil];
    for (NSManagedObject* item in items) {
        [context deleteObject:item];
    }
}

- (void)clearBuddiesUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[Buddy entity] name] usingContext:context];
}

- (void)clearUserAttributesUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[UserAttribute entity] name] usingContext:context];
}

- (void)clearUserPhotosUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[UserPhoto entity] name] usingContext:context];
}

- (void)clearMessagesUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[Message entity] name] usingContext:context];
}

- (void)clearChatsPhotosUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[Chat entity] name] usingContext:context];
}

- (void)clearBuddyRequestsPhotosUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[BuddyRequest entity] name] usingContext:context];
}

- (void)clearFilesUsingContext:(NSManagedObjectContext *)context {
    [self clearEntity:[[File entity] name] usingContext:context];
}

- (void)destroyAllData {
    NSManagedObjectContext *context = [self backgroundContext];
    
    [context performBlock:^{
        [self clearBuddiesUsingContext:context];
        [self clearUserPhotosUsingContext:context];
        [self clearUserAttributesUsingContext:context];
        [self clearChatsPhotosUsingContext:context];
        [self clearFilesUsingContext:context];
        [self clearMessagesUsingContext:context];
        
        NSError *error;
        [context save:&error];
        [self resetChatRoomSubscritionsUsingContext:context error:&error];
       
        if(error) {
            [[LoggerController sharedInstance] logError:error];
        }
    }];
}

- (void)resetChatRoomSubscritionsUsingContext:(NSManagedObjectContext *)context error:(NSError **)error {
    NSBatchUpdateRequest *updateChatRoomSubscriptionsRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[ChatRoom entity] name]];
    [updateChatRoomSubscriptionsRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    [updateChatRoomSubscriptionsRequest setPropertiesToUpdate:@{@"isSubscribed": @NO}];
    [updateChatRoomSubscriptionsRequest setResultType:NSUpdatedObjectIDsResultType];
    [context executeRequest:updateChatRoomSubscriptionsRequest error: error];
}

- (AnyPromise *)updateUsername:(NSString *)username {
    NSString *currentUsername = [[PersistencyManager sharedInstance] getUsername];
    NSString *newUsername = [username lowercaseString];
    
    NSBatchUpdateRequest *updateChatFromPropertyRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[ChatMessage entity] name]];
    NSPredicate *fromPropertyPredicate = [NSPredicate predicateWithFormat:@"from == %@", currentUsername];
    [updateChatFromPropertyRequest setPredicate:fromPropertyPredicate];
    [updateChatFromPropertyRequest setPropertiesToUpdate:@{@"from": newUsername}];
    [updateChatFromPropertyRequest setResultType:NSUpdatedObjectIDsResultType];
    
    NSBatchUpdateRequest *updateChatToPropertyRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[ChatMessage entity] name]];
    NSPredicate *toPropertyPredicate = [NSPredicate predicateWithFormat:@"to == %@", currentUsername];
    [updateChatToPropertyRequest setPredicate:toPropertyPredicate];
    [updateChatToPropertyRequest setPropertiesToUpdate:@{@"to": newUsername}];
    [updateChatToPropertyRequest setResultType:NSUpdatedObjectIDsResultType];
    
    NSBatchUpdateRequest *updateUserPhotosRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[UserPhoto entity] name]];
    NSPredicate *usernamePropertyPredicate = [NSPredicate predicateWithFormat:@"username == %@", currentUsername];
    [updateUserPhotosRequest setPredicate:usernamePropertyPredicate];
    [updateUserPhotosRequest setPropertiesToUpdate:@{@"username": newUsername}];
    [updateUserPhotosRequest setResultType:NSUpdatedObjectIDsResultType];
    
    NSBatchUpdateRequest *updateUserAttributesRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[UserAttribute entity] name]];
    [updateUserAttributesRequest setPredicate:usernamePropertyPredicate];
    [updateUserAttributesRequest setPropertiesToUpdate:@{@"username": newUsername}];
    [updateUserAttributesRequest setResultType:NSUpdatedObjectIDsResultType];
    
    NSBatchUpdateRequest *updateChatRoomSubscriptionsRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:[[ChatRoom entity] name]];
    [updateChatRoomSubscriptionsRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    [updateChatRoomSubscriptionsRequest setPropertiesToUpdate:@{@"isSubscribed": @NO}];
    [updateChatRoomSubscriptionsRequest setResultType:NSUpdatedObjectIDsResultType];
    
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [context performBlock:^{
            NSBatchUpdateResult *toResult = [context executeRequest:updateChatToPropertyRequest error:nil];
            NSBatchUpdateResult *fromResult = [context executeRequest:updateChatFromPropertyRequest error:nil];
            NSBatchUpdateResult *photosResult = [context executeRequest:updateUserPhotosRequest error:nil];
            NSBatchUpdateResult *attributesResult = [context executeRequest:updateUserAttributesRequest error:nil];
            NSBatchUpdateResult *chatRoomsResult = [context executeRequest:updateChatRoomSubscriptionsRequest error:nil];

            [[PersistencyManager sharedInstance] saveUsername:newUsername];
            [[PersistencyManager sharedInstance] saveUsernameChangeRequestId:nil];
            resolve(nil);
        }];
    }];
}

@end
