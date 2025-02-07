//
//  UserPhoto+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/12/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersistencyManager.h"
#import "PersistencyManager.h"
@import UIKit;
@class UserDataModel;
@class Buddy;

NS_ASSUME_NONNULL_BEGIN

@interface UserPhoto : NSManagedObject
+ (AnyPromise *)myAvatarUsingContext:(NSManagedObjectContext *)context;
+ (AnyPromise *)avatarForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;
- (AnyPromise *)image;

+ (instancetype)myUserPhotoUsingContext:(NSManagedObjectContext *)context;
+ (instancetype)userPhotoForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;
+ (void)deletePhotoForUsername:(NSString *)username withIndex:(NSUInteger)index usingContext:(NSManagedObjectContext *)context;
+ (NSArray *)photosForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;
+ (instancetype)newPhotoForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "UserPhoto+CoreDataProperties.h"
