//
//  LocalNotificationsController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/29/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
#import "LocalNotificationsController.h"

@import UserNotifications;
@import AudioToolbox;
@import CoreData;
#import "CoreDataStack.h"
#import "Message+CoreDataClass.h"
#import "BuddyRequest+CoreDataClass.h"
#import "PersistencyManager.h"
#import "Constants.h"
#import "Bubbles-Swift.h"

@interface LocalNotificationsController()
+ (NSUInteger)totalUnreadMessagesCount;
@end

@implementation LocalNotificationsController {
    UNUserNotificationCenter *center;
}
- (BOOL)shouldSendNotification {
    return [[PersistencyManager sharedInstance] isNotificaionsEnabled];
}

+ (id)sharedInstance {
    static LocalNotificationsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    }
    return self;
}

- (void)sendNotificationWithCategory:(NSString *)category withIdentifier:(NSString *)identifier andData:(NSDictionary *)data enforce:(BOOL)enforce {
    if ([self shouldSendNotification] || enforce) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:data];
        
        if ([category isEqualToString:@"roster"]) {
            [content setTitle:@"New friend request"];
            [content setBody:[mutableDict objectForKey:@"from"]];
        } else if ([category isEqualToString:@"chat"]) {
            [content setTitle:[[mutableDict objectForKey:@"from"] uppercaseString]];
            [content setBody:[mutableDict objectForKey:@"message"]];
            [mutableDict setObject:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_MESSAGE forKey:@"action"];
        } else if ([category isEqualToString:@"groupchat"]) {
            [content setTitle:[[mutableDict objectForKey:@"from"] uppercaseString]];
            [content setBody:[mutableDict objectForKey:@"message"]];
            [mutableDict setObject:PUSH_NOTIFICATION_ACTION_MESSAGE_NEW_GROUP_MESSAGE forKey:@"action"];
        } else if ([category isEqualToString:@"headline"]) {
            [content setTitle:[mutableDict objectForKey:@"title"]];
            
            NSString *status = [mutableDict objectForKey:@"body"];
            
            NSString *body = @"";
            if ([status isEqualToString:@"1"]) {
                body = NSLocalizedString(@"registration_status_rejected_incorrect_documents_hint", nil);
            } else if ([status isEqualToString:@"2"]) {
                body = NSLocalizedString(@"registration_status_rejected_illegible_documents_hint", nil);
            } else if ([status isEqualToString:@"3"]) {
                body = NSLocalizedString(@"registration_status_approved_hint", nil);
            }
            
            [content setBody:body];
        }
        
        [content setUserInfo:mutableDict];
        [content setCategoryIdentifier:category];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }
}

- (void)removeNotificationWithIdentifier:(NSString *)identifier {
    if (!identifier) { return; }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
        [LocalNotificationsController setAppBadgeNumber];
    });
}

+ (NSUInteger)totalUnreadMessagesCount {
    NSManagedObjectContext *managedObjectContext = [[CoreDataStack sharedInstance] mainContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Message class])];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"sumOfUnreadCounts";
    expressionDescription.expression = [NSExpression expressionForKeyPath:@"@sum.isUnread"];
    expressionDescription.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[expressionDescription];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result == nil) {
        NSLog(@"Error: %@", error);
        return 0;
    }
    else {
        return [[[result objectAtIndex:0] objectForKey:@"sumOfUnreadCounts"] integerValue];
    }
}

+ (NSUInteger)unreadChatMessagesCount {
    NSManagedObjectContext *managedObjectContext = [[CoreDataStack sharedInstance] mainContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ChatMessage class])];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"sumOfUnreadCounts";
    expressionDescription.expression = [NSExpression expressionForKeyPath:@"@sum.isUnread"];
    expressionDescription.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[expressionDescription];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result == nil) {
        NSLog(@"Error: %@", error);
        return 0;
    }
    else {
        return [[[result objectAtIndex:0] objectForKey:@"sumOfUnreadCounts"] integerValue];
    }
}

+ (NSUInteger)unreadGroupMessagesCount {
    NSManagedObjectContext *managedObjectContext = [[CoreDataStack sharedInstance] mainContext];
    
    NSFetchRequest *postsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Post class])];
    postsFetchRequest.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"sumOfUnreadPostCounts";
    expressionDescription.expression = [NSExpression expressionForKeyPath:@"@sum.isUnread"];
    expressionDescription.expressionResultType = NSDecimalAttributeType;
    
    postsFetchRequest.propertiesToFetch = @[expressionDescription];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:postsFetchRequest error:&error];
    if (result == nil) {
        NSLog(@"Error: %@", error);
        return 0;
    }
    else {
        return [[[result objectAtIndex:0] objectForKey:@"sumOfUnreadPostCounts"] integerValue];
    }
}

+ (NSUInteger)buddyRequestsCount {
    NSManagedObjectContext *managedObjectContext = [[CoreDataStack sharedInstance] mainContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BuddyRequest class])];
    
    NSError *error = nil;
    NSUInteger result = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (result == NSNotFound) {
        NSLog(@"Error: %@", error);
        return 0;
    } else {
        return result;
    }
}

+ (void)setAppBadgeNumber {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self totalUnreadMessagesCount]];
}

@end
