//
//  ViewController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

@import AsyncDisplayKit;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : ASDKViewController
@property (strong, nonatomic) NSString *navTitle;
@property (strong, nonatomic) NSString *navSubtitle;
@property (strong, nonatomic) UIColor *navColor;
- (void)languageDidChange;
- (void)setNavTitle:(NSString *)title;
- (void)setNavTitle:(NSString *)title subtitle:(NSString * _Nullable)subtitle;
@end

NS_ASSUME_NONNULL_END
