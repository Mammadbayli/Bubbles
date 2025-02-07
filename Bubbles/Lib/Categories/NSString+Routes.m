//
//  NSString+Routes.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/4/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "NSString+Routes.h"

@implementation NSString (Routes)

+(NSString *) identityVerification {
    return @"identityVerification";
}

+(NSString *) phoneVerification {
    return @"phoneVerification";
}

+(NSString *) sms {
    return @"sms";
}

+(NSString *) userInfo {
    return @"userInfo";
}

+(NSString *)phoneVerificationSuccess {
    return @"phoneSuccess";
}

+(NSString *)userAccount {
    return @"userAccount";
}

+(NSString *)tabBarController {
     return @"tabBarController";
}

+(NSString *)searchUsers {
    return @"searchUsers";
}

+(NSString *)friendRequests {
    return @"friendRequests";
}

+(NSString *)chats {
    return @"chats";
}

+(NSString *)settings {
    return @"settings";
}

+(NSString *)chat {
    return @"chat";
}


@end
