//
//  AppDelegate.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+NFSColors.h"
#import "BundleLocalization.h"
#import "LocalNotificationsController.h"
#import "PersistencyManager.h"
#import "RegistrationController.h"
#import "Constants.h"
#import "RemoteNotificationsController.h"
#import "XMPPController+Authentication.h"
#import "XMPPController+Presence.h"
#import "XMPPController+Messaging.h"
#import "CoreDataStack.h"
#import "CertificatePinningURLSessionDelegate.h"
#import "NavigationController.h"
#import "RosterController.h"
#import "XMPPMessage+CustomFields.h"
#import <Bubbles-Swift.h>

@import IQKeyboardManager;
@import Firebase;
@import FirebaseCrashlytics;
@import FirebaseAnalytics;
@import Network;

#ifdef FIREBASE_SANDBOX
#define __FIREBASE_SANDBOX YES
#else
#define __FIREBASE_SANDBOX NO
#endif

@interface AppDelegate()<FIRMessagingDelegate>
@property (strong, nonatomic) NSString *fcmToken;
@property (strong, nonatomic) dispatch_queue_t monitorQueue;
@property (strong, nonatomic) nw_path_monitor_t monitor;
@property (nonatomic) BOOL shouldTryToConnect;
@property (strong, nonatomic, nullable) NFSTabViewContainer *tabBarController;

- (void)navigateToPostWithId:(NSString *)postId;
- (void)navigateToChatWithUser:(NSString *)username;
- (void)navigateToUsernameChange;
- (void)navigateToRoster;
@end

@implementation AppDelegate

- (NFSTabViewContainer *)tabBarController {
    if(!_tabBarController) {
        _tabBarController = [[NFSTabViewContainer alloc] init];
    }
    
    return _tabBarController;
}

- (void)resetToInitialState {
    [self setInitialState];
}

- (void)refreshApp {
    [self setTabBarController:nil];
    self.window.rootViewController = [[self tabBarController] viewController];
}

- (void)setInitialState {
    [[self window] setRootViewController:[WelcomeViewContainer create]];
    [self setTabBarController:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _shouldTryToConnect = YES;
    
    [[BundleLocalization sharedInstance] setLanguage:[[PersistencyManager sharedInstance] getLanguagePrefence]];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [PersistencyManager sharedInstance];
    [self setupFirebase];
    [self setupWindow];
    [self setupNetworkMonitoring];
    [self tryToconnect];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setQualityOfService:NSQualityOfServiceUserInteractive];
    typeof(self) __weak weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:XMPP_STREAM_DID_AUTHENTICATE_NOTIFICATION
                                                      object:nil 
                                                       queue:queue
                                                  usingBlock:^(NSNotification * _Nonnull notification) {
        [weakSelf authenticated];
    }];
    
    if (![[PersistencyManager sharedInstance] isRegistered]) {
        [[GroupsController sharedInstance] loadGroups];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[XMPPController sharedInstance] goOffline];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[XMPPController sharedInstance] disconnect];
    [LocalNotificationsController setAppBadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self tryToconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[XMPPController sharedInstance] goOnline];
    [self handleDeliveredNotifications];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSURL *url = [userActivity webpageURL];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if(__FIREBASE_SANDBOX) {
        [[FIRMessaging messaging] setAPNSToken:deviceToken
                                          type:FIRMessagingAPNSTokenTypeSandbox];
    } else {
        [[FIRMessaging messaging] setAPNSToken:deviceToken
                                          type:FIRMessagingAPNSTokenTypeProd];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FCMToken"
                                                             object:nil
                                                           userInfo:nil];
}

- (void)authenticated {
    _shouldTryToConnect = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self setupTabBar];
    });
    
    if ([self fcmToken]) {
        [[RemoteNotificationsController sharedInstance] saveToken:[self fcmToken]];
    }
    
    [[GroupsController sharedInstance] subscribeToChatRooms];
    [[XMPPController sharedInstance] resendUnsentMessages];
}

- (void)setupNetworkMonitoring {
    dispatch_queue_attr_t attrs = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    self.monitorQueue = dispatch_queue_create("com.example.network-monitor", attrs);
    
    // self.monitor = nw_path_monitor_create_with_type(nw_interface_type_wifi);
    _monitor = nw_path_monitor_create();
    nw_path_monitor_set_queue(self.monitor, self.monitorQueue);
    nw_path_monitor_set_update_handler(self.monitor, ^(nw_path_t _Nonnull path) {
        nw_path_status_t status = nw_path_get_status(path);
        // Determine the active interface, but how?
        switch (status) {
            case nw_path_status_invalid: {
                // Network path is invalid
                break;
            }
            case nw_path_status_satisfied: {
                // Network is usable
                [self tryToconnect];
                break;
            }
            case nw_path_status_satisfiable: {
                // Network may be usable
                [self tryToconnect];
                break;
            }
            case nw_path_status_unsatisfied: {
                // Network is not usable
                break;
            }
        }
    });
    
    nw_path_monitor_start(self.monitor);
}

- (void)tryToconnect {
    if([[PersistencyManager sharedInstance] isRegistered]) {
        [[XMPPController sharedInstance] authenticate];
    }
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    if (fcmToken) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FCMToken"
                                                            object:nil
                                                          userInfo:dataDict];
        
        [self setFcmToken:fcmToken];
        [[RemoteNotificationsController sharedInstance] saveToken:[self fcmToken]];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSString *action = [[[[notification request] content] userInfo] objectForKey:@"action"];
    if([action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_NEW_FRIEND_REQUEST] ||
       [action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_ACCEPT_FRIEND_REQUEST] ||
       [action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_DECLINE_FRIEND_REQUEST]) {
        [[RosterController sharedInstance] fetchRoster];
        
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
    } else if([action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE] ||
              [action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE]) {
        NSString *notifTitle = [[[notification request] content] title];
        if([notifTitle caseInsensitiveCompare:[self currentChat]] == NSOrderedSame ||
           [notifTitle caseInsensitiveCompare:[self currentPost]] == NSOrderedSame) {
            completionHandler(UNNotificationPresentationOptionNone);
        } else {
            completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
        }
    } else if([action isEqualToString:PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE
                                                            object:nil];
    }
}

- (void)setupWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    [[self window] makeKeyAndVisible];

    if([[PersistencyManager sharedInstance] isRegistered]) {
        [self setupTabBar];
    } else {
        [self setInitialState];
    }
}

- (void)setupTabBar {
    if(![[self.window.rootViewController accessibilityLabel] isEqualToString:@"tabbar"]) {
        self.window.rootViewController = [[self tabBarController] viewController];
    }
}

- (void)setupFirebase {
    [FIRApp configure];
    [[FIRMessaging messaging] setDelegate:self];
    [FIRAnalytics setAnalyticsCollectionEnabled:YES];
    [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:YES];
    
    if ([UNUserNotificationCenter class] != nil) {
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    }
    
    if([[PersistencyManager sharedInstance] isNotificaionsEnabled]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *actionIdentifier = [response actionIdentifier];
    UNNotification *notification = [response notification];
    NSArray *notifications = @[notification];
    
    if ([actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        [self handleNotifications:notifications];
    } else if ([actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {
        [self saveMessagesFromNotifications:notifications];
    }
    
    completionHandler();
}

- (void)handleDeliveredNotifications {
    [[UNUserNotificationCenter currentNotificationCenter]
     getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        [self saveMessagesFromNotifications:notifications];
    }];
}

- (void)handleNotifications:(NSArray<UNNotification *> *)notifications {
    return [self handleNotifications:notifications 
                        usingContext:[[XMPPController sharedInstance] messageSaveContext]];
}

- (void)handleNotifications:(NSArray<UNNotification *> *)notifications usingContext:(NSManagedObjectContext *)context {
    NSEnumerator *reverseEnumerator = [notifications reverseObjectEnumerator];
    UNNotification *notification;
    
    while(notification = [reverseEnumerator nextObject]) {
        UNNotificationRequest *request = [notification request];
        NSString *action = [[[request content] userInfo] objectForKey:@"action"];
        
        if([action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE] ||
           [action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE]) {
            NSManagedObjectID *messageID = [self addMessageFromNotificationContent:[request content] toContext:context];
            
            Message *message = [context objectWithID:messageID];
            if (message) {
                if ([message isKindOfClass:[ChatMessage class]]) {
                    [self navigateToChatWithUser:[(ChatMessage *)message chatId]];
                } else if ([message isKindOfClass:[Post class]]) {
                    Post *post = (Post *)message;
                    [self navigateToPostWithId:[post uniqueId]];
                } else if ([message isKindOfClass:[Comment class]]) {
                    Post *post = [(Comment *)message post];
                    [self navigateToPostWithId:[post uniqueId]];
                }
            }
        } else if([action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_NEW_FRIEND_REQUEST] ||
                  [action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_ACCEPT_FRIEND_REQUEST] ||
                  [action isEqualToString:PUSH_NOTIFICATION_ACTION_ROSTER_DECLINE_FRIEND_REQUEST]) {
            [[RosterController sharedInstance] fetchRoster];
            [self navigateToRoster];
            
            [[LocalNotificationsController sharedInstance] removeNotificationWithIdentifier:[request identifier]];
            
        } else if ([action isEqualToString:PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE] && [self tabBarController]) {
            [self navigateToUsernameChange];
            
            [[LocalNotificationsController sharedInstance] removeNotificationWithIdentifier:[request identifier]];
        }
    }
}

- (void)saveMessagesFromNotifications:(NSArray<UNNotification *> *)notifications {
    NSManagedObjectContext *context = [[XMPPController sharedInstance] messageSaveContext];
    [context performBlock:^{
        [self saveMessagesFromNotifications:notifications usingContext:context];
    }];
}

- (AnyPromise *)saveMessagesFromNotifications:(NSArray<UNNotification *> *)notifications usingContext:(NSManagedObjectContext *)context {
    NSEnumerator *reverseEnumerator = [notifications reverseObjectEnumerator];
    UNNotification *notification;
    
    while(notification = [reverseEnumerator nextObject]) {
        UNNotificationRequest *request = [notification request];
        NSString *action = [[[request content] userInfo] objectForKey:@"action"];
        
        if([action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE] ||
           [action isEqualToString:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE]) {
            [self addMessageFromNotificationContent:[request content] toContext:context];
            [[LocalNotificationsController sharedInstance] removeNotificationWithIdentifier:[request identifier]];
        }
    }
    
    if ([[context insertedObjects] count]) {
        return [[CoreDataStack sharedInstance] saveContext:context];
    } else {
        return [AnyPromise promiseWithValue:[NSNull null]];
    }
}

- (NSManagedObjectID *)addMessageFromNotificationContent:(UNNotificationContent *)content toContext:(NSManagedObjectContext *)context {
    XMPPMessage *xmppMessage = [self xmppMessageFromNotificationContent:content];
    NSManagedObjectID *objectId = [[XMPPController sharedInstance] addMessage:xmppMessage
                                                                    toContext:context];
    
    return  objectId;
}

- (XMPPMessage *)xmppMessageFromNotification:(UNNotification *)notification {
    UNNotificationContent *content = [[notification request] content];
    return [self xmppMessageFromNotificationContent:content];
}

- (XMPPMessage *)xmppMessageFromNotificationContent:(UNNotificationContent *)content {
    NSDictionary *userInfo = [content userInfo];
    
    NSString *messageXML = [userInfo objectForKey:@"stanza"];
    messageXML = [messageXML stringByReplacingOccurrencesOfString:@"xml:lang='en'" withString:@""];
    messageXML = [messageXML stringByReplacingOccurrencesOfString:@"xml:lang=\"en\"" withString:@""];
    
    return [[XMPPMessage alloc] initWithXMLString:messageXML error:nil];
}

@end
