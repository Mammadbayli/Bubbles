//
//  XMPPController+Messaging.m
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController+Messaging.h"
#import "Constants.h"
#import "CoreDataStack.h"
#import "Comment+CoreDataClass.h"
#import "Post+CoreDataClass.h"
#import "LocalNotificationsController.h"
#import "XMPPMessage+CustomFields.h"
#import "ChatRoom+CoreDataClass.h"
#import "ChatRoomCategory+CoreDataClass.h"
#import "NSString+JID.h"
#import "XMPPController+Private.h"
#import "LoggerController.h"
#import "Bubbles-Swift.h"

@implementation XMPPController (Messaging)
- (void)sendMessage:(Message *)message {
    [[self xmppStream] sendElement:[message xmlRepresentation]];
}

- (void)startComposingWithChatId:(NSString *)chatId {
    XMPPMessage *message = [[XMPPMessage alloc] initWithType:@"chat" to:[chatId jid]];
    [message addComposingChatState];
    [[self xmppStream] sendElement:message];
}

- (void)pauseComposingWithChatId:(NSString *)chatId {
    XMPPMessage *message = [[XMPPMessage alloc] initWithType:@"chat" to:[chatId jid]];
    [message addPausedChatState];
    [[self xmppStream] sendElement:message];
}

- (void)becomeActiveWithChatId:(NSString *)chatId {
    XMPPMessage *message = [[XMPPMessage alloc] initWithType:@"chat" to:[chatId jid]];
    [message addActiveChatState];
    [[self xmppStream] sendElement:message];
}

- (void)becomeGoneWithChatId:(NSString *)chatId {
    XMPPMessage *message = [[XMPPMessage alloc] initWithType:@"chat" to:[chatId jid]];
    [message addGoneChatState];
    [[self xmppStream] sendElement:message];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    NSString *messageId = [message attributeStringValueForName:@"id"];
    [ChatMessage updateDeliveryStatus:MESSAGE_STATUS_FAILED forMessageId:messageId usingContext:[self messageSaveContext]];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSString *messageId = [message attributeStringValueForName:@"id"];
    [ChatMessage updateDeliveryStatus:MESSAGE_STATUS_SENT forMessageId:messageId usingContext:[self messageSaveContext]];
}

- (void)resendUnsentMessages {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    [context performBlock:^{
        NSFetchRequest *request = [ChatMessage fetchRequest];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deliveryStatus in %@", @[MESSAGE_STATUS_FAILED, MESSAGE_STATUS_PENDING]];
        [request setPredicate:predicate];
        
        NSArray *messages = [context executeFetchRequest:request error:nil];
        
        for (ChatMessage *message in messages) {
            [message send];
        }
    }];
}

- (AnyPromise *)handleChatMessage:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs {
    ChatMessage *chatMessage = [ChatMessage withXmppMessage:message andContext:context];
    
    BOOL shouldDisplayNotification = [[context insertedObjects] containsObject:chatMessage];
    
    return [[CoreDataStack sharedInstance] saveContext:[self messageSaveContext]].then(^{
        [context performBlock:^{
            if(shouldDisplayNotification) {
                [self displayNotificationForMessage:chatMessage];
            }
        }];

        return [chatMessage objectID];
    });
}

-(AnyPromise *)handleGroupChatMessage:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs {
    if([message elementForName:@"parent"]) {
        return [self handleComment:message
                      usingContext:context
                objectIDsToRefresh:objectIDs];
    } else {
        return [self handlePost:message
                   usingContext:context
             objectIDsToRefresh:objectIDs];
    }
    
    return [AnyPromise promiseWithValue: [NSError errorWithDomain:@"error" code:-1 userInfo:nil]];
}

- (AnyPromise *)handlePost:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs {
    Post *post = [[Post alloc] initWithXMPPMessage:message andContext:context];
    [post setIsUnread:NO];
    
    NSManagedObjectID *categoryObjectId = [[[post room] category] objectID];
    
    if (objectIDs && categoryObjectId) {
        [*objectIDs addObject:categoryObjectId];
    }
    
    return [[CoreDataStack sharedInstance] saveContext:[self messageSaveContext]]
        .then(^{
            return [post objectID];
        });
}

- (AnyPromise *)handleComment:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs {
    Comment *comment = [[Comment alloc] initWithXMPPMessage:message
                                                 andContext:context];

    BOOL __block shouldDisplayNotification = NO;

    Post *post = [comment post];
    [[post comments] enumerateObjectsUsingBlock:^(Comment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj from] isEqualToString:[self myUsername]]) {
            shouldDisplayNotification = [[context insertedObjects] containsObject:comment];
        }
    }];

    [comment setIsUnread: shouldDisplayNotification];

    NSManagedObjectID *roomObjectID = [[[comment post] room] objectID];
    
    if (objectIDs && roomObjectID) {
        [*objectIDs addObject:roomObjectID];
        
        NSManagedObjectID *categoryObjectId = [[[[comment post] room] category] objectID];
        
        if (categoryObjectId) {
            [*objectIDs addObject:categoryObjectId];
        }
    }
    
    return [[CoreDataStack sharedInstance] saveContext:[self messageSaveContext]].then(^{
        if(shouldDisplayNotification) {
            [self displayNotificationForMessage:comment];
        }

        return [comment objectID];
    });
}

- (void)displayNotificationForMessage:(Message *)message {
    if (!message) {
        [[LoggerController sharedInstance] logError:[NSError errorWithDomain:@"error"
                                                                        code:-1
                                                                    userInfo:@{@"error": @"message_nil"}]];
        return;
    }
    
    NSString *from = [message notificationTitle];
    NSString *body = [message textRepresentation];
    NSString *stanza = [[message xmlRepresentation] XMLString];
    
    if (from && body && stanza) {
        NSDictionary *data = @{@"from": from,
                               @"message": body,
                               @"stanza": stanza,
        };
        
        NSString *category;
        
        if([message isKindOfClass:[ChatMessage class]]) {
            category = @"chat";
        } else if([message isKindOfClass:[Post class]]) {
            category = @"groupchat";
        } else if([message isKindOfClass:[Comment class]]) {
            category = @"groupchat";
        } else {
            category = @"other";
        }

        if ([[[message xmlRepresentation] type] isEqualToString:@"groupchat"]) {
            [[LocalNotificationsController sharedInstance] sendNotificationWithCategory:@"chat"
                                                                         withIdentifier: [message uniqueId]
                                                                                andData:data
                                                                                enforce:NO];
        }

    } else if([message uniqueId]) {
        [[LoggerController sharedInstance] logError:[NSError errorWithDomain:@"error"
                                                                        code:-1
                                                                    userInfo:@{@"empty _local_message_id": [message uniqueId]}]];
    } else {
        [[LoggerController sharedInstance] logError:[NSError errorWithDomain:@"error"
                                                                        code:-1
                                                                    userInfo:@{@"empty _local_message": @"malformed"}]];
    }
}

- (XMPPMessage *)unwrapMessage:(XMPPMessage *)message {
    if([message elementForName:@"event"]) {
        NSXMLElement *event = [message elementForName:@"event"];
        NSXMLElement *items = [event elementForName:@"items"];
        NSArray *array = [items elementsForName:@"item"];
        
        for (NSXMLElement *item in array) {
            NSXMLElement *messageXML = [item elementForName:@"message"];
            return [XMPPMessage messageFromElement:messageXML];
        }
    }
    
    return message;
}

- (AnyPromise *)handleMessage:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs {
    Message *existingMessage = [Message findMessageWithMessageId:[message messageId] usingContext:context];
    if (existingMessage) {
        return [AnyPromise promiseWithValue:[existingMessage objectID]];
    } else if ([message isChatMessage]) {
        return [self handleChatMessage:message
                          usingContext:context
                    objectIDsToRefresh:objectIDs];
    } else if([message isGroupChatMessage]) {
        return [self handleGroupChatMessage:message
                          usingContext:context
                    objectIDsToRefresh:objectIDs];
    } else if([message elementForName:@"event"]) {
        NSXMLElement *event = [message elementForName:@"event"];
        NSXMLElement *items = [event elementForName:@"items"];
        NSArray *array = [items elementsForName:@"item"];
        
        for (NSXMLElement *item in array) {
            NSXMLElement *messageXML = [item elementForName:@"message"];
            XMPPMessage *message = [XMPPMessage messageFromElement:messageXML];
        
            return [self handleGroupChatMessage:message
                              usingContext:context
                        objectIDsToRefresh:objectIDs];
        }
    }
    
    return [AnyPromise promiseWithValue: [NSError errorWithDomain:@"error" code:-1 userInfo:nil]];
}

- (NSManagedObjectID *)addMessage:(XMPPMessage *)message toContext:(NSManagedObjectContext *)context {
    Message *existingMessage = [Message findMessageWithMessageId:[message messageId] usingContext:context];
    
    if (!existingMessage) {
        if ([message isChatMessage]) {
            existingMessage = [ChatMessage withXmppMessage:message andContext:context];
        } else if ([message isPost]) {
            existingMessage = [[Post alloc] initWithXMPPMessage:message andContext:context];
        } else if ([message isComment]) {
            existingMessage = [[Comment alloc] initWithXMPPMessage:message andContext:context];
        }
    }
    
    return [existingMessage objectID];
}

- (void)handleChatStateMessage:(XMPPMessage *)message {
    NSString *username = [[message from] user];
    if ([message hasComposingChatState]) {
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:USER_COMPOSING_NOTIFICATION
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": username}]];
    } else if ([message hasPausedChatState]) {
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:USER_PAUSED_COMPOSING_NOTIFICATION
                                                                                             object:nil
                                                                                           userInfo:@{@"jid": username}]];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message isErrorMessage]) {//Ignore error messages
        return;
    }
    
    if ([message hasChatState]) {
        [self handleChatStateMessage:message];
        return;
    }
    
    if([message deliveredReceiptID]) {
        [ChatMessage updateDeliveryStatus:MESSAGE_STATUS_DELIVERED
                             forMessageId:[message deliveredReceiptID]
                             usingContext:[self messageSaveContext]];
        return;
    }
    
    if([message readReceiptID]) {
        [ChatMessage updateDeliveryStatus:MESSAGE_STATUS_READ
                             forMessageId:[message readReceiptID]
                             usingContext:[self messageSaveContext]];
        
        return;
    }
    
    XMPPMessage *unwrappedMessage = [self unwrapMessage:message];
    
    [[self messageSaveContext] performBlock:^{
        NSMutableSet *objectIDs = [[NSMutableSet alloc] init];
        [self handleMessage:unwrappedMessage
               usingContext:[self messageSaveContext]
         objectIDsToRefresh:&objectIDs].then(^(NSManagedObjectID *objectId){
            NSManagedObjectContext *mainContext = [[CoreDataStack sharedInstance] mainContext];
            [mainContext performBlock:^{
                for (NSManagedObjectID *objectId in objectIDs) {
                    NSManagedObject *object = [mainContext objectWithID:objectId];
                    [mainContext refreshObject:object mergeChanges:NO];
                }
            }];
        });
    }];
}
@end
