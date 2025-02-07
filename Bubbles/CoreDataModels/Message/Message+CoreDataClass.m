//
//  Message+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/9/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Message+CoreDataClass.h"
#import "NSString+FilePath.h"
#import "Constants.h"
#import "XMPPController.h"
#import "XMPPMessage+CustomFields.h"
#import "CoreDataStack.h"
#import "PersistencyManager.h"
#import "NSString+JID.h"
#import "Bubbles-Swift.h"

@implementation Message
@dynamic xmlRepresentation;
@dynamic  notificationTitle;
@dynamic textRepresentation;

- (instancetype)initWithXMPPMessage:(XMPPMessage *)xmppMessage andContext :(NSManagedObjectContext *)context {
    Message *message = [Message findMessageWithMessageId:[xmppMessage messageId] usingContext:context];
    
    if (message) {
        self = message;
    } else {
        self = [super initWithContext:context];
    }

    if(self) {
        [self parseXMPPMessage:xmppMessage];
    }
    
    return self;
}

- (instancetype)initWithContext:(NSManagedObjectContext *)moc {
    self = [super initWithContext:moc];
    
    if(self) {
        [self setUniqueId:[[[XMPPController sharedInstance] xmppStream] generateUUID]];
        NSString *from = [[PersistencyManager sharedInstance] getUsername];
        [self setFrom:from];
        [self setTimestamp:[NSDate now]];
    }
    
    return self;
}

- (NSString *)senderTitle {
    if ([[self from] isEqualToString:[[XMPPController sharedInstance] myUsername]]) {
        return @"message_from_you";
    }
    
    return [[self from] uppercaseString];
}

- (void)setFilesArray:(NSArray *)files withType:(nonnull NSString *)type {
//    NSMutableOrderedSet *fls = [[NSMutableOrderedSet alloc] init];
    for (NSData *photo in files) {
        File *file = [[File alloc] initWithContext:[self managedObjectContext]];
        [file setData:photo];
        [file setType:type];
        [file setMessage:self];
//        [fls addObject:file];
    }
    
//    [self setFiles:fls];
}

- (AnyPromise *)uploadFiles {
    NSMutableArray *promises = [[NSMutableArray alloc] init];
    
    for (File *file in [self files]) {
        [promises addObject:[file upload]];
    }
    
    return PMKWhen(promises);
}

- (AnyPromise *)downloadFirstFile {
    File *file = [[self files] firstObject];
    
    if (file) {
        return [[[self files] firstObject] download];
    }
  
    return [AnyPromise promiseWithValue:[NSError errorWithDomain:@"alert" code:-1 userInfo:nil]];
}

- (AnyPromise *)downloadFiles {
    NSMutableArray *promises = [[NSMutableArray alloc] init];
    
    for (File *file in [self files]) {
        [promises addObject:[file download]];
    }
    
    return PMKWhen(promises);
}

+ (Message *)findMessageWithMessageId:(NSString *)messageId usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [Message fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueId == %@)", messageId];
    [request setPredicate:predicate];
    [request setFetchLimit:1];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    return [results firstObject];
}


- (NSString *)timestampString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:[self timestamp]];
    
    return time;
}

- (XMPPMessage *)xmlRepresentation {
    XMPPMessage *xmppMessage = [[XMPPMessage alloc] init];

    [xmppMessage addAttributeWithName:@"from" stringValue:[[[self from] jid] full]];
    [xmppMessage setMessageId:[self uniqueId]];
    
    NSString *text = [self body];
    if([text length] > 0) {
        [xmppMessage addBody:text];
    }
    
    [xmppMessage setTimestamp:[self timestamp]];
    
    for (File *file in [self files]) {
        [xmppMessage addFile:[file name] withType:[file type]];
    }
    
    return xmppMessage;
}

- (void)parseXMPPMessage:(XMPPMessage *)xmppMessage {
    [self setUniqueId:[xmppMessage messageId]];
    [self setBody:[xmppMessage body]];
    
    for (NSDictionary *file in [xmppMessage files]) {
        File *_file = [[File alloc] initWithContext:[self managedObjectContext]];
        [_file setName:file[@"name"]];
        [_file setType:file[@"type"]];
        [_file setMessage:self];
        [_file download];
    }

    [self setTo:[[xmppMessage to] user]];
    
    if([[xmppMessage type] isEqualToString:@"groupchat"] && [[xmppMessage from] resource]) {
        [self setFrom:[[xmppMessage from] resource]];
    } else {
        [self setFrom:[[xmppMessage from] user]];
    }
    
    NSDate *timestamp = [xmppMessage timestamp];
    if(timestamp) {
        [self setTimestamp:timestamp];
    }
    
    [self setIsUnread:YES];
}

- (BOOL)isOutgoing {
    NSString *myUsername = [[PersistencyManager sharedInstance] getUsername];
    return [[self from] isEqualToString:myUsername];
}

- (void)setStarred:(BOOL)starred {
    [self setIsStarred:starred];
    [self save];
}

- (void)setRead {
    if ([self isUnread]) {
        [self setIsUnread:NO];
        
        [[self managedObjectContext] performBlock:^{
            [[self managedObjectContext] save:nil];
            [[self managedObjectContext] refreshObject:[(Post *)self room] mergeChanges:YES];
            [[self managedObjectContext] refreshObject:[[(Post *)self room] category] mergeChanges:YES];
        }];
    }

}

- (void)send {
    [self save];
    [self uploadFiles].then(^{
        [[XMPPController sharedInstance] sendMessage:self];
    });
}

- (AnyPromise *)save {
    NSManagedObjectContext *context = [self managedObjectContext];
    return [[CoreDataStack sharedInstance] saveContext:context];
}

- (void)markAsReadWithCompletionBlock:(void (NS_NOESCAPE ^_Nullable)(NSManagedObjectContext * _Nonnull, NSManagedObject * _Nonnull))block {
    if ([self isUnread]) {
        NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
        [context performBlock:^{
            Message *message = [context objectWithID:[self objectID]];
            [message setIsUnread:NO];
            if ([context hasChanges]) {
                [[CoreDataStack sharedInstance] saveContextThreadUnsafe:context
                                                                  error:nil];
            }
            
            if (block) {
                block(context, message);
            }
        }];
    }
}

- (void)markAsRead {
    
}

- (void)refresh {
    [[self managedObjectContext] refreshObject:self mergeChanges:YES];
}

@end
