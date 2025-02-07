//
//  NSString+Routes.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/4/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Routes)
+(NSString *) identityVerification;
+(NSString *) phoneVerification;
+(NSString *) sms;
+(NSString *) userInfo;
+(NSString *) phoneVerificationSuccess;
+(NSString *) userAccount;
+(NSString *) tabBarController;
+(NSString *) searchUsers;
+(NSString *) friendRequests;
+(NSString *) chats;
+(NSString *) settings;
+(NSString *) chat;
@end

NS_ASSUME_NONNULL_END
