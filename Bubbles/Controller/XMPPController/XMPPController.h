//
//  XMPPController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/2/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

@import XMPPFramework;
#import "Message+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMPPController: NSObject
+ (instancetype)sharedInstance;

- (void)sendMessage:(Message *)message;
- (void)connect;
- (void)disconnect;
- (void)subscribeToRoomWithId:(NSString *)roomId;
- (void)sendReadReceiptForMessage:(Message *)message;

@property (strong, nonatomic, readonly) NSString *myUsername;
@property (strong, nonatomic, readonly) XMPPStream *xmppStream;
@property (strong, nonatomic, readonly) NSManagedObjectContext *messageSaveContext;

@end

NS_ASSUME_NONNULL_END
