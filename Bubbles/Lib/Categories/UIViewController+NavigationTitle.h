//
//  UIViewController+NavigationTitle.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ViewController (NavigationTitle)
- (void)setNavTitle:(NSString*)title;
- (void)setNavTitle:(NSString*)title subtitle:(NSString*)subtitle;
@end

