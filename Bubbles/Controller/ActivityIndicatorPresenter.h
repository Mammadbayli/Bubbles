//
//  ActivityIndicatorPresenter.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityIndicatorPresenter : NSObject
+ (instancetype)sharedInstance;
-(void)present;
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
