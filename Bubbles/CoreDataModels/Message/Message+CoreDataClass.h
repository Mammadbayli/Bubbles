//
//  Message+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/9/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import XMPPFramework;
@import PromiseKit;

@class Buddy;

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

@property (strong, nonatomic, readonly) XMPPMessage *xmlRepresentation;
@property (nonatomic, readonly) BOOL isOutgoing;
@property (strong, nonatomic, readonly) NSString *timestampString;
@property (nonatomic, readonly, strong) NSString *textRepresentation;
@property (nonatomic, readonly, strong) NSString *notificationTitle;
@property (nonatomic, readonly, strong) NSString *senderTitle;


+ (instancetype)findMessageWithMessageId:(NSString *)messageId usingContext:(NSManagedObjectContext *)context;
- (instancetype)initWithXMPPMessage:(XMPPMessage *)xmppMessage andContext:(NSManagedObjectContext *)context;

- (void)send;
- (void)setStarred:(BOOL)starred;
- (void)setRead;
- (AnyPromise *)save;
- (void)setFilesArray:(NSArray *)files withType:(NSString *)type;
- (void)refresh;

- (void)markAsReadWithCompletionBlock:(void (NS_NOESCAPE ^_Nullable)(NSManagedObjectContext *_Nonnull context, NSManagedObject *_Nonnull message))block;
- (void)markAsRead;

- (AnyPromise *)uploadFiles;
- (AnyPromise *)downloadFiles;
- (AnyPromise *)downloadFirstFile;

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
