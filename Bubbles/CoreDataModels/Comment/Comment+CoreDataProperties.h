//
//  Comment+CoreDataProperties.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Comment+CoreDataClass.h"
#import "Post+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment (CoreDataProperties)

+ (NSFetchRequest<Comment *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, retain) Post *post;

@end

NS_ASSUME_NONNULL_END
