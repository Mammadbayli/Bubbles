//
//  LocalNotificationsController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/29/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationsController : NSObject
+ (instancetype)sharedInstance;
- (void)sendNotificationWithCategory:(NSString *)category withIdentifier:(NSString *)identifier andData:(NSDictionary *)data enforce:(BOOL)enforce;
- (void)removeNotificationWithIdentifier:(NSString *)identifier;
+ (void)setAppBadgeNumber;
+ (NSUInteger)unreadChatMessagesCount;
+ (NSUInteger)unreadGroupMessagesCount;
+ (NSUInteger)buddyRequestsCount;
@end

NS_ASSUME_NONNULL_END
