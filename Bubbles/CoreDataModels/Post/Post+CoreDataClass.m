//
//  Post+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Post+CoreDataClass.h"
#import "Constants.h"
#import "CoreDataStack.h"
#import "XMPPController.h"
#import "XMPPMessage+CustomFields.h"
#import "NSString+JID.h"
#import "Bubbles-Swift.h"

@implementation Post

- (instancetype)initWithXMPPMessage:(XMPPMessage *)xmppMessage andContext:(NSManagedObjectContext *)context {
    self = [super initWithXMPPMessage:xmppMessage andContext:context];
    
    if (self) {
        [self setTitle:[xmppMessage subject]];
        
        ChatRoom *room = [ChatRoom roomWithId:[[xmppMessage from] user] usingContext:context];
        if (!room) {
            room = [ChatRoom roomWithId:[[xmppMessage to] user] usingContext:context];
        }
        [self setRoom:room];
    }
    
    return self;
}

- (int16_t)unreadCount {
    int16_t count = [self isUnread];
    
    for (Comment *comment in [self comments]) {
        count += [comment isUnread];
    }
    
    return count;
}

- (NSString *)notificationTitle {
    return [NSString stringWithFormat:@"%@@%@", [[self from] uppercaseString], [[[self room] roomId] uppercaseString]];
}

- (NSString *)textRepresentation {
    return [self title];
}

- (XMPPMessage *)xmlRepresentation {
    XMPPJID *jid = [[[self room] roomId] groupJid];
    XMPPMessage *message = [super xmlRepresentation];
    [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    [message addAttributeWithName:@"to" stringValue:[jid full]];
    [message addSubject:[self title]];
    
    return message;
}

- (void)shareWithUser:(NSString *)username {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] mainContext];
    
    Chat *chat = [Chat getWithUser:username using:context];
    
    PostMessage *message = [[PostMessage alloc] initWithContext:context];
    [message setPost:[context objectWithID:[self objectID]]];
    [message setChat:chat];
    [message setTo:username];
    [message send];
}

- (void)refresh {
    [super refresh];
    
    [[self room] refresh];
}

- (NSString *)timestampString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.YYYY HH:mm"];
    NSString *time = [formatter stringFromDate:[self timestamp]];
    return time;
}

@end
