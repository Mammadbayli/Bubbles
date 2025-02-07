//
//  AlertViewController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "ViewController.h"
#import "AlertViewControllerAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertViewController : ASDKViewController
- (void)addAction: (AlertViewControllerAction*)action;
- (void)setMessage:(NSString *)message;
- (void)setAttributedMessage:(NSAttributedString *)attributedMessage;
- (void)setImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
