//
//  File+CoreDataClass.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 11.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersistencyManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface File: NSManagedObject
- (void)setData:(NSData *)data;
- (AnyPromise *)upload;
- (AnyPromise *)download;
- (File *)copyWithContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "File+CoreDataProperties.h"
