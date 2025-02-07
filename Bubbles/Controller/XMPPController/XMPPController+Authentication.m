//
//  XMPPController+Authentication.m
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController+Authentication.h"
#import "PersistencyManager.h"
#import "Constants.h"
#import "NSString+JID.h"
#import "XMPPController+Presence.h"
#import "XMPPController+Private.h"
#import "AppDelegate.h"
#import "RosterController.h"

@implementation XMPPController (Authentication)
- (void)authenticate {
    if (![[self xmppStream] isAuthenticated]) {
        NSString *username = [[PersistencyManager sharedInstance] getUsername];
        NSString *password = [[PersistencyManager sharedInstance] getPassword];
        
        [self authenticateWithUsername:username andPassword:password];
    }
}

- (void)authenticateWithUsername:(NSString*)username andPassword:(NSString *)password {
    [self setPassword:password];
    
    XMPPJID *jid = [username jid];
    [[self xmppStream] setMyJID:jid];
    
    [self authenticateWithPassword:password];
}

- (void)authenticateWithPassword:(NSString *)password {
    if([[self xmppStream] isConnected]) {
        if(![[self xmppStream] isAuthenticated]) {
            NSError *error = nil;
            
            if(![[self xmppStream] authenticateWithPassword:password error:&error]) {
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION
                                                                                                     object:error]];
            }
        }
    } else {
        [self connect];
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION
                                                                                             object:nil]];
    });
    
    [self sendPresence];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:XMPP_STREAM_DID_NOT_AUTHENTICATE_NOTIFICATION
                                                                                             object:error]];
    });
}

- (void)clearAuthenticationData {
    [[self xmppStream] setMyJID:nil];
}
@end
