//
//  NavigationController.h
//  Bubbles
//
//  Created by Javad on 13.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationController : ASDKNavigationController
@property (strong, nonatomic) UIColor *navColor;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end

NS_ASSUME_NONNULL_END
