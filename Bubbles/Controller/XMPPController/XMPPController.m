//
//  XMPPController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/2/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController.h"
#import "AlertPresenter.h"
#import "PersistencyManager.h"
#import "CoreDataStack.h"
#import "NSURL+LocalFileURL.h"
#import "NSString+FilePath.h"
#import "NSString+JSONParsing.h"
#import "UserPhoto+CoreDataClass.h"
#import "UserAttribute+CoreDataClass.h"
#import "Post+CoreDataClass.h"
#import "Comment+CoreDataClass.h"
#import "ChatRoom+CoreDataClass.h"
#import "NSString+JID.h"
#import "XMPPMessage+CustomFields.h"
#import "XMPPController+Messaging.h"
#import "XMPPController+Private.h"
#import "RosterController.h"
#import "Bubbles-Swift.h"

@interface XMPPController()<XMPPStreamDelegate, XMPPRosterDelegate, XMPPReconnectDelegate>
@property (strong, nonatomic, readonly) XMPPReconnect *xmppReconnect;
@end

@implementation XMPPController {
    NSManagedObjectContext *_messageSaveContext;
}

- (NSString *)myUsername {
    return [[[self xmppStream] myJID] user];
}

- (NSManagedObjectContext *)messageSaveContext {
    if (!_messageSaveContext) {
        _messageSaveContext = [[CoreDataStack sharedInstance] backgroundContext];
    }
    
    return _messageSaveContext;
}

+ (instancetype)sharedInstance {
    static XMPPController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream setHostName:SERVER_HOST_NAME];
        [_xmppStream addDelegate:self delegateQueue:queue];
        
        XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:queue];
        [xmppMessageDeliveryRecipts setAutoSendMessageDeliveryReceipts:YES];
        [xmppMessageDeliveryRecipts setAutoSendMessageDeliveryRequests:YES];
        [xmppMessageDeliveryRecipts activate:_xmppStream];
        
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect activate:_xmppStream];
        [_xmppReconnect addDelegate:self delegateQueue:queue];
        
        _xmppLastActivity = [[XMPPLastActivity alloc] initWithDispatchQueue:queue];
        [_xmppLastActivity setRespondsToQueries:YES];
        [_xmppLastActivity addDelegate:self delegateQueue:queue];
        [_xmppLastActivity activate:_xmppStream];
    }
    
    return self;
}

- (void)subscribeToRoomWithId:(NSString *)roomId {
    NSXMLElement *subscribe = [NSXMLElement elementWithName:@"subscribe" xmlns:@"urn:xmpp:mucsub:0"];
    [subscribe addAttributeWithName:@"nick" stringValue:[[self myJID] user]];
    
    NSXMLElement *event = [NSXMLElement elementWithName:@"event"];
    [event addAttributeWithName:@"node" stringValue:@"urn:xmpp:mucsub:nodes:messages"];
    [subscribe addChild:event];
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"id" stringValue:@"group_subscription"];
    [iq addAttributeWithName:@"to" stringValue:[[roomId groupJid] full]];
    [iq addAttributeWithName:@"from" stringValue:[[self myJID] bare]];
    [iq addChild:subscribe];
    
    [self.xmppStream sendElement:iq];
}

- (XMPPJID *)myJID {
    return [[self xmppStream] myJID];
}

- (void)connect {
    if(![[self xmppStream] isConnected] && ![[self xmppStream] isConnecting]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_START_CONNECTING_NOTIFICATION
                                                                                                 object:nil]];
        });

        NSError *error = nil;
        if (![[self xmppStream] connectWithTimeout:10 error:&error]) {
            NSLog(@"Oops, I probably forgot something: %@", error);
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_CONNECT_NOTIFICATION
                                                                                                 object:nil]];
        }
    }
}

- (void)disconnect {
    [[self xmppStream] disconnectAfterSending];
    [[self xmppStream] setMyJID:nil];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_CONNECT_NOTIFICATION 
                                                                                         object:nil]];
    
    [RosterController sharedInstance];
    
    if(![[self xmppStream] isAuthenticated]) {
        NSError *error = nil;
        
        if(![[self xmppStream] authenticateWithPassword:[self password] error:&error]) {
            NSLog(@"Oops, I probably forgot something: %@", error);
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION
                                                                                                 object:error]];
        }
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_DISCONNECT_NOTIFICATION 
                                                                                         object:nil]];
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_CONNECT_NOTIFICATION
                                                                                         object:nil]];
}

- (void)xmppStreamWasToldToAbortConnect:(XMPPStream *)sender {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_CONNECT_NOTIFICATION
                                                                                         object:nil]];
}

//MARK: XMPPStreamDelegate methods
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    if([[iq elementID] isEqualToString:@"group_subscription"]) {
        NSString *roomId = [iq fromStr];
        NSManagedObjectContext *context = [[CoreDataStack sharedInstance] mainContext];
        ChatRoom *group = [ChatRoom roomWithId:roomId usingContext:context];
        [group setSubscribed];
    }
    
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error {
    
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {
    
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error {
    
}

//MARK: XMPPReconnectDelegate methods
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_START_CONNECTING_NOTIFICATION object:nil]];
    });
    
    return YES;
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags {
}
@end
