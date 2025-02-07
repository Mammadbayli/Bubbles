//
//  ChatRoom+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import XMPPFramework;

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoom : NSManagedObject

+ (instancetype)roomWithId:(NSString *)roomId usingContext:(NSManagedObjectContext *)context;
+ (instancetype)roomWithObject:(NSDictionary* )object usingContext:(NSManagedObjectContext *)context;
- (void)parseObject:(NSDictionary *)object;
- (void)subscribe;
- (void)setSubscribed;
- (void)refresh;
- (XMPPJID *)jid;

@end

NS_ASSUME_NONNULL_END

#import "ChatRoom+CoreDataProperties.h"
