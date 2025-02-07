//
//  RosterController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/17/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "RosterController.h"
#import "RosterController_Private.h"
#import "XMPPController.h"
#import "Constants.h"
#import "CoreDataStack.h"
#import "BuddyRequest+CoreDataClass.h"
#import "PersistencyManager.h"
#import "Buddy+CoreDataClass.h"
#import "NSString+JID.h"
#import "APIRequest.h"
#import "NSURLSession+CertificatePinning.h"
#import "ActivityIndicatorPresenter.h"
#import "AlertPresenter.h"
#import "NSError+PromiseKit.h"
#import "ProfileController.h"

@interface RosterController()
@property (atomic) BOOL isFetchingRoster;
@end

@implementation RosterController
- (XMPPStream *)xmppStream {
    return [[XMPPController sharedInstance] xmppStream];
}

- (NSString *)myUsername {
    return [[PersistencyManager sharedInstance] getUsername];
}

+ (instancetype)sharedInstance {
    static RosterController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        
        _xmppRosterStorage = [XMPPRosterMemoryStorage new];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage dispatchQueue:queue];
        [_xmppRoster activate:[self xmppStream]];
        [_xmppRoster setAutoFetchRoster:YES];
        [_xmppRoster addDelegate:self delegateQueue:queue];
        //        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    }
    return self;
}

- (AnyPromise *)syncRoster:(NSArray *)items {
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
        
        [context performBlock:^{
            NSMutableArray *usernames = [[NSMutableArray alloc] init];
            NSMutableArray *inboundRequests = [[NSMutableArray alloc] init];
            
            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *username = [obj objectForKey:@"friend_user_id"];
                NSString *subscription = [obj objectForKey:@"type"];
                if (username && ![subscription isEqualToString:@"in"]) {
                    [usernames addObject:username];
                } else {
                    [inboundRequests addObject:username];
                }
            }];
            
            NSArray *deletedObjectIDs = [[self deleteRosterItemsNotIn:usernames usingContext:context]
                                         arrayByAddingObjectsFromArray:[self deleteBuddyRequestsNotIn:inboundRequests usingContext:context]];
            
            [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: deletedObjectIDs}
                                                         intoContexts:@[[[CoreDataStack sharedInstance] mainContext]]];
            
            Buddy *buddy = nil;
            
            for(NSDictionary<NSString*, NSString*> *item in items) {
                NSString *username = [item objectForKey:@"friend_user_id"];
                NSString *subscription = [item objectForKey:@"type"];
                
                if ([subscription isEqualToString:@"both"]) {
                    buddy = [Buddy buddyWithUsername:username usingContext:context];
                    
                    if(!buddy) {
                        buddy = [[Buddy alloc] initWithContext:context];
                        [buddy setUsername:username];
                    }
                    
                    BOOL isInRoster = [subscription isEqualToString:@"both"];
                    if ([buddy isInRoster] != isInRoster) {
                        [buddy setIsInRoster:isInRoster];
                    }
                } else if ([subscription isEqualToString:@"out"]) {
                    buddy = [Buddy buddyWithUsername:username usingContext:context];
                    
                    if(!buddy) {
                        buddy = [[Buddy alloc] initWithContext:context];
                        [buddy setUsername:username];
                    }
                } else if ([subscription isEqualToString:@"in"]) {
                    [[RosterController sharedInstance] addBuddyRequest:username];
                }
            }
            
            NSError *error = nil;
            if ([context hasChanges]) {
                [[CoreDataStack sharedInstance] saveContextThreadUnsafe:context error:&error];
            }
            
            resolve([NSNull null]);
        }];
    }];
    
    return promise;
}

- (id)deleteRosterItemsNotIn:(NSArray *)usernames usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [Buddy fetchRequest];
    //delete those that are not in remote db
    [request setPredicate:[NSPredicate predicateWithFormat:@"NOT (username in %@)", usernames]];
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
    NSBatchDeleteResult *result = [context executeRequest:batchDeleteRequest error:nil];
    
    return [result result];
}

- (id)deleteBuddyRequestsNotIn:(NSArray *)buddyRequests usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [BuddyRequest fetchRequest];
    //delete those that are not in remote db
    [request setPredicate:[NSPredicate predicateWithFormat:@"NOT (username in %@)", buddyRequests]];
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
    NSBatchDeleteResult *result = [context executeRequest:batchDeleteRequest error:nil];
    
    return [result result];
}

- (AnyPromise *)fetchRoster {
    if ([self isFetchingRoster]) { return  [AnyPromise promiseWithValue:[NSNull null]]; }
    [self setIsFetchingRoster:YES];
    
    NSString *path = [NSString stringWithFormat:@"roster/%@", [self myUsername]];
    NSMutableURLRequest *request = [APIRequest GETRequestWithPath:path];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    return [session promiseDataTaskWithRequest:request]
        .then(^(id reply) {
            return [self syncRoster:reply];
        }).ensure(^() {
            [self setIsFetchingRoster:NO];
        });
}

- (AnyPromise *)deleteRosterItem:(NSString *)rosterItem {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:rosterItem forKey:@"friend_user_id"];
    
    NSString *path = [NSString stringWithFormat:@"roster/%@", [self myUsername]];
    
    NSMutableURLRequest *request = [APIRequest DELETERequestWithPath:path andData:dict];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    return [session promiseDataTaskWithRequest:request]
        .then(^(id reply) {
            [[RosterController sharedInstance] removeBuddyFromRoster:rosterItem];
        })
        .catch(^(NSError *error){
            [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
            @throw error;
        })
        .ensure(^() {
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}

- (AnyPromise *)sendFriendRequestToUser:(NSString *)username {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"to"];
    
    NSString *path = [NSString stringWithFormat:@"roster/%@/send-friend-request", [self myUsername]];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:path andData:dict];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    return [session promiseDataTaskWithRequest:request]
        .then(^{
            [[AlertPresenter sharedInstance] presentWithTitle:@"Info" message:@"friend_requests_request_sent"];
        })
        .catch(^(NSError *error){
            [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
            @throw error;
        })
        .ensure(^() {
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}

- (AnyPromise *)acceptBuddyRequest:(BuddyRequest *)buddyRequest {
    NSString *username = [buddyRequest username];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"from"];
    
    NSString *path = [NSString stringWithFormat:@"roster/%@/accept-friend-request", [self myUsername]];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:path andData:dict];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    return [session promiseDataTaskWithRequest:request]
        .catch(^(NSError *error){
            [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
            @throw error;
        })
        .ensure(^() {
            [self removeBuddyRequest:username];
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}

- (AnyPromise *)declineBuddyRequest:(BuddyRequest *)buddyRequest {
    NSString *username = [buddyRequest username];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"from"];
    
    NSString *path = [NSString stringWithFormat:@"roster/%@/reject-friend-request", [self myUsername]];
    
    NSMutableURLRequest *request = [APIRequest POSTRequestWithPath:path andData:dict];
    NSURLSession *session = [NSURLSession certificatePinnedSession];
    
    [[ActivityIndicatorPresenter sharedInstance] present];
    return [session promiseDataTaskWithRequest:request]
        .catch(^(NSError *error){
            [[AlertPresenter sharedInstance] presentErrorWithMessage:[error message]];
            @throw error;
        })
        .ensure(^() {
            [self removeBuddyRequest:username];
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}

- (void)addBuddyRequest:(NSString *)username {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    
    [context performBlock:^{
        Buddy *buddy = [Buddy buddyWithUsername:username usingContext:context];
        
        if (!buddy) {
            BuddyRequest *buddyRequest = [BuddyRequest buddyRequestWithUsername:username usingContext:context];
            
            if (!buddyRequest) {
                NSFetchRequest *req = [Buddy fetchRequest];
                [req setPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
                
                if (![context countForFetchRequest:req error:nil]) {
                    BuddyRequest *buddyRequest = [[BuddyRequest alloc] initWithContext:context];
                    [buddyRequest setUsername:username];
                    NSError *error;
                    
                    [[CoreDataStack sharedInstance] saveContextThreadUnsafe:context error:&error];
                }
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"new-buddy-request"
                                                        object:nil
                                                      userInfo:nil];
}

- (void)removeBuddyRequest:(NSString *)username {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    [context performBlock:^{
        BuddyRequest *buddyRequest = [BuddyRequest buddyRequestWithUsername:username usingContext:context];
        
        [[CoreDataStack sharedInstance] deleteObject:buddyRequest
                                        usingContext:context];
    }];
}

- (AnyPromise *)removeBuddyFromRoster:(NSString *)username {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    
    Buddy *buddy = [Buddy buddyWithUsername:username usingContext:context];
    return [[CoreDataStack sharedInstance] deleteObject:buddy
                                           usingContext:context];
}

- (void)addBuddyToRosterWithUsername:(NSString *)username {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    
    [context performBlock:^{
        Buddy *buddy = [Buddy buddyWithUsername:username usingContext:context];
        if (!buddy) {
            buddy = [[Buddy alloc] initWithContext:context];
            [buddy setUsername:username];
        }
        
        [buddy setIsInRoster:YES];
        
        [[CoreDataStack sharedInstance] saveContextThreadUnsafe:context error:nil];
    }];
}

- (NSFetchedResultsController *)rosterFetchedResultsController {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] mainContext];
    
    NSFetchRequest *request = [Buddy fetchRequest];
    
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sectionTitle" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]]];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:@"sectionTitle"
                                                                                            cacheName:nil];
    
    return controller;
}
@end
