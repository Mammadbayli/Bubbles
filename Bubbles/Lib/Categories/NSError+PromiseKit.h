//
//  NSError+PromiseKit.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 5/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (PromiseKit)
@property (strong, readonly, nonatomic) NSString *message;
@end

NS_ASSUME_NONNULL_END
