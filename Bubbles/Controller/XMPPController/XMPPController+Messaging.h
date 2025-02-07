//
//  XMPPController+Messaging.h
//  Bubbles
//
//  Created by Javad Mammadbeyli on 809//2020.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "XMPPController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMPPController (Messaging)

- (void)sendMessage:(Message *)message;
- (void)startComposingWithChatId:(NSString *)chatId;
- (void)pauseComposingWithChatId:(NSString *)chatId;
- (void)becomeActiveWithChatId:(NSString *)chatId;
- (void)becomeGoneWithChatId:(NSString *)chatId;
- (AnyPromise *)handleMessage:(XMPPMessage *)message usingContext:(NSManagedObjectContext *)context objectIDsToRefresh:(NSMutableSet<NSManagedObjectID *> **)objectIDs;
- (NSManagedObjectID *)addMessage:(XMPPMessage *)message toContext:(NSManagedObjectContext *)context;
- (void)resendUnsentMessages;

@end

NS_ASSUME_NONNULL_END
