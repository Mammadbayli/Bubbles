//
//  SplitViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/7/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "SplitViewController.h"
#import "UIColor+NFSColors.h"

@interface SplitViewController () <UISplitViewControllerDelegate>

@end

@implementation SplitViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDelegate:self];
        [self setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    return self;
}

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(nullable id)sender {
//    if (!splitViewController.collapsed) {
//        [[[[(UINavigationController*)vc viewControllers] firstObject] view] setBackgroundColor:[UIColor redColor]];
////        [[vc view] setBackgroundColor:[UIColor redColor]];
//    }
//    
//    return NO;
//}


- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

@end
