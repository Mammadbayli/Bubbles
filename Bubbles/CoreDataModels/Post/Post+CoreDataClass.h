//
//  Post+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/21/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Message+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : Message
- (void)shareWithUser:(NSString *)username;

@end

NS_ASSUME_NONNULL_END

#import "Post+CoreDataProperties.h"
