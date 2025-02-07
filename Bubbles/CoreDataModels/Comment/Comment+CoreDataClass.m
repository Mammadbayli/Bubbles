//
//  Comment+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Comment+CoreDataClass.h"
#import "XMPPMessage+CustomFields.h"
#import "NSString+JID.h"
#import "CoreDataStack.h"
#import "Post+CoreDataClass.h"
#import "Bubbles-Swift.h"

@implementation Comment

- (instancetype)initWithXMPPMessage:(XMPPMessage *)xmppMessage andContext:(NSManagedObjectContext *)context {
    XMPPMessage *parent = [XMPPMessage messageFromElement:[xmppMessage parent]];
    Post *post = (Post *)[Post findMessageWithMessageId:[parent messageId] usingContext:context];
    
    if(!post) {
        post = [[Post alloc] initWithXMPPMessage:parent andContext:context];
    }
    
    if (post) {
        self = [super initWithXMPPMessage:xmppMessage andContext:context];
        
        if (self) {
            [self setPost:post];
        }
        
        return self;
    }
    
    return nil;
}

- (NSString *)notificationTitle {
    return [NSString stringWithFormat:@"%@@%@", [[self from] uppercaseString], [[[[self post] room] roomId] uppercaseString]];
}

- (NSString *)textRepresentation {
    return [self body];
}

- (XMPPMessage *)xmlRepresentation {
    XMPPJID *to = [[[[self post] room] roomId] groupJid];
    XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" to:to];
    
    [message setMessageId:[self uniqueId]];
    
    NSString *text = [self body];
    if([text length] > 0) {
        [message addBody:text];
    }
    
    [message setTimestamp:[self timestamp]];
    [message setParentId:[[self post] uniqueId]];
    
    XMPPMessage *parent = [[self post] xmlRepresentation];
    XMPPJID *from = [parent from];
    XMPPJID *newFrom = [[[[self post] room] jid] jidWithNewResource:[from user]];
    [parent removeAttributeForName:@"from"];
    [parent addAttributeWithName:@"from" stringValue:[newFrom full]];
    if (parent) {
        [message setParent:parent];
        return message;
    }

    return nil;
}

- (void)markAsRead {
    [super markAsReadWithCompletionBlock:^(NSManagedObjectContext * _Nonnull context, NSManagedObject * _Nonnull message) {
        NSManagedObjectContext *mainContext = [[CoreDataStack sharedInstance] mainContext];
        Comment *comment = (Comment *)message;
        
        [mainContext performBlock:^{
            Comment *mainContextComment = [mainContext objectWithID:[comment objectID]];
            [[mainContextComment post] refresh];
        }];
    }];
}

- (void)refresh {
    [super refresh];
    
    [[self post] refresh];
}

- (NSString *)timestampString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.YYYY HH:mm"];
    NSString *time = [formatter stringFromDate:[self timestamp]];
    return time;
}
@end
