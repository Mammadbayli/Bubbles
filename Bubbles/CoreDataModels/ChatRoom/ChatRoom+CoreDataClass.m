//
//  ChatRoom+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoom+CoreDataClass.h"
#import "CoreDataStack.h"
#import "Comment+CoreDataClass.h"
#import "Constants.h"
#import "XMPPController.h"

@implementation ChatRoom

- (XMPPJID *)jid {
    NSString *domain = [NSString stringWithFormat:@"conference.%@", VIRTUAL_HOST_NAME];
    return [XMPPJID jidWithUser:[self roomId] domain:domain resource:nil];
}

+ (instancetype)roomWithId:(NSString *)roomId usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [ChatRoom fetchRequest];
    [request setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomId== %@", roomId];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error) {
       return nil;
    }
 
    return (ChatRoom *)[result firstObject];
}

+ (instancetype)roomWithObject:(NSDictionary*)object usingContext:(NSManagedObjectContext*)context {
    ChatRoom *group = [[ChatRoom alloc] initWithContext:context];
    [group parseObject:object];
    
    return group;
}

- (int16_t)unreadCount {
    int16_t count = 0;
    
    for (Post *post in [self posts]) {
        count += [post unreadCount];
    }
    
    return count;
}

- (void)setSubscribed {
    [self setIsSubscribed:YES];
    [[self managedObjectContext] save:nil];
}

- (void)parseObject:(NSDictionary*)object {
    NSString *name = [object objectForKey:@"name"];
    NSString *icon = [object objectForKey:@"icon"];
    NSString *roomId= [object objectForKey:@"id"];
    
    NSURL *iconUrl = [NSURL URLWithString:icon];
    
    if(![[self name] isEqualToString:name]) {
        [self setName:name];
    }
    if(![[self icon] isEqual:iconUrl]) {
        [self setIcon:iconUrl];
    }
    if(![[self roomId] isEqualToString:roomId]) {
        [self setRoomId:roomId];
    }
}

- (void)subscribe {
    if ([[PersistencyManager sharedInstance] getUsername] && [[[PersistencyManager sharedInstance] getUsername] length] == 9) {
        [[XMPPController sharedInstance] subscribeToRoomWithId:[self roomId]];
        [[self managedObjectContext] performBlock:^{
            [self setIsSubscribed:YES];
            [[self managedObjectContext] save:nil];
        }];
    }
}

- (void)refresh {
    [[self managedObjectContext] refreshObject:self mergeChanges:YES];
    [[self managedObjectContext] refreshObject:[self category] mergeChanges:YES];
}
@end
