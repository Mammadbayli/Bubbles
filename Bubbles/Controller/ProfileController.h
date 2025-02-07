//
//  ProfileController.h
//  Bubbles
//
//  Created by Javad on 25.07.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileController : NSObject
+ (instancetype)sharedInstance;
- (AnyPromise *)getProfileForUsername:(NSString *)userId;
- (AnyPromise *)setProfileValue:(NSDictionary *)value ForKey:(NSString *)key ForUsername:(NSString *)username;
- (AnyPromise *)updateProfilePictures:(NSArray *)pictures forUsername:(NSString *)username withContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END
