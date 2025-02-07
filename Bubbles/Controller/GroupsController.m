//
//  GroupsController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/30/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "GroupsController.h"
#import "Constants.h"
#import "NSError+PromiseKit.h"
#import "ChatRoom+CoreDataClass.h"
#import "CoreDataStack.h"
#import "ChatRoomCategory+CoreDataClass.h"
#import "APIRequest.h"
#import "NSURLSession+CertificatePinning.h"
@import PromiseKit;

@implementation GroupsController
+ (instancetype)sharedInstance {
    static GroupsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)subscribeToChatRooms {
    NSFetchRequest *request = [ChatRoom fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubscribed  == %@", [NSNumber numberWithBool:NO]];
    [request setPredicate:predicate];
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    [context performBlock:^{
        NSArray *rooms = [context executeFetchRequest:request error:nil];
        for(ChatRoom * room in rooms) {
            [room subscribe];
        }
        [context save:nil];
    }];
}

- (void)parseGroupsUsingContext:(NSManagedObjectContext*)context andCategory:(NSDictionary*)category {
    NSString *categoryId = [category objectForKey:@"id"];
    
    NSMutableArray *groupIds = [[NSMutableArray alloc] init];
    NSArray *rooms = [category objectForKey:@"rooms"];
    for(NSDictionary *room in rooms) {
        [groupIds addObject:[room objectForKey:@"id"]];
    }
    
    NSFetchRequest *request = [ChatRoom fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (roomId in %@) AND category.categoryId == %@", groupIds, categoryId];
//    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    [request setPredicate:predicate];
    
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
    
    NSError *error;
    NSBatchDeleteResult *batchDeleteResult = [context executeRequest:batchDeleteRequest error:&error];
    NSArray *deletedObjectIDs = [batchDeleteResult result];
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: deletedObjectIDs}
                                                 intoContexts:@[[[CoreDataStack sharedInstance] mainContext]]];
    
    for(NSDictionary *room in rooms) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomId== %@", [room objectForKey:@"id"]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if(!error && [results count] == 0) {
            ChatRoom *group = [ChatRoom roomWithObject:room usingContext:context];
            ChatRoomCategory *category = [ChatRoomCategory categoryWithCategoryId:categoryId usingContext:context];
            [group setCategory:category];
        } else if(!error && [results count] == 1) {
            ChatRoom *group = [results firstObject];
            [group parseObject:room];
        }
    }
}

- (void)parseGroupCategoriesUsingContext:(NSManagedObjectContext*)context andReply:(id)reply {
    NSMutableArray *categoryIds = [[NSMutableArray alloc] init];
    
    for(NSDictionary *object in reply) {
        [categoryIds addObject:[object objectForKey:@"id"]];
    }
    
    NSFetchRequest *request = [ChatRoomCategory fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (categoryId in %@)", categoryIds];
    [request setPredicate:predicate];
    
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
    
    NSError *error;
    NSBatchDeleteResult *batchDeleteResult = [context executeRequest:batchDeleteRequest error:&error];
    NSArray *deletedObjectIDs = [batchDeleteResult result];
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: deletedObjectIDs}
                                                 intoContexts:@[[[CoreDataStack sharedInstance] mainContext]]];
    
    
    for(NSDictionary *object in reply) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %@", [object objectForKey:@"id"]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if(!error && [results count] == 0) {
            ChatRoomCategory *category = [ChatRoomCategory categoryWithObject:object usingContext:context];
            [context insertObject:category];
        } else if(!error && [results count] == 1) {
            ChatRoomCategory *category = [results firstObject];
            [category parseObject:object];
        }
        
        [self parseGroupsUsingContext:context andCategory:object];
    }
}

- (AnyPromise *)loadGroups {
    NSMutableURLRequest *request = [APIRequest GETRequestWithPath:@"groups"];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    return [session promiseDataTaskWithRequest:request].then(^(id reply) {
        NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
        [context performBlock:^{
            [self parseGroupCategoriesUsingContext:context andReply:reply];
        }];

        return [[CoreDataStack sharedInstance] saveContext:context];
    }).catch(^(id err) {
        
    });
}
@end
