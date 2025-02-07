//
//  AppDelegate.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UserNotifications;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
- (void)resetToInitialState;
- (void)refreshApp;
- (void)navigateToPostWithId:(NSString *)postId;

@property (strong, nonatomic, nullable) NSString *currentChat;
@property (strong, nonatomic, nullable) NSString *currentPost;
@end

