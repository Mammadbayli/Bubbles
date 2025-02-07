//
//  iPadAccountViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/6/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "iPadAccountViewController.h"
#import "UIColor+NFSColors.h"
#import "UIFont+NFSFonts.h"
#import "SettingsViewController.h"
#import "AccountViewController.h"
#import "NSNumber+Dimensions.h"
#import "CoreDataStack.h"
#import "PersistencyManager.h"
#import "XMPPController.h"


@implementation iPadAccountViewController {
    NSDictionary *data;
    ASDKNavigationController *_accountVC;
    ASDKNavigationController *_settingsVC;
}

- (ASDKNavigationController *)accountVC {
    if (!_accountVC) {
        NSString *myUsername = [[PersistencyManager sharedInstance] getUsername];
        
        AccountViewController *vc = [[AccountViewController alloc] initWithUser:myUsername andIsViewingSelf:YES];
        _accountVC = [[ASDKNavigationController alloc] initWithRootViewController:vc];
        
        if (YES) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
                UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"\uea03" style:UIBarButtonItemStylePlain target:self action:@selector(navigateToSettings)];

                
                [buttonItem setTitleTextAttributes:@{ NSFontAttributeName: [[UIFont NFSFont] fontWithSize:25] } forState:UIControlStateNormal];
                [buttonItem setTitleTextAttributes:@{ NSFontAttributeName: [[UIFont NFSFont] fontWithSize:25] } forState:UIControlStateSelected];
                [buttonItem setTintColor:[UIColor textColor]];
                [[vc navigationItem] setRightBarButtonItem: buttonItem];
            }
        }
    }
    
    return _accountVC;
}

- (ASDKNavigationController *)settingsVC {
    if (!_settingsVC) {
        SettingsViewController *vc = [[SettingsViewController alloc] init];
        _settingsVC = [[ASDKNavigationController alloc] initWithRootViewController:vc];
    }
    
    return _settingsVC;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setViewControllers:@[[self accountVC], [self settingsVC]]];
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-gear"] selectedImage:nil]];
        
        typeof(self) __weak weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:@"change-username" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf updateTabbarItem];
        }];
    }
    return self;
}

- (void)updateTabbarItem {
    if (![[self view] window]) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-gear-badge"] selectedImage:nil]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-gear"] selectedImage:nil]];
    [[self tabBarController] setSelectedViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMinimumPrimaryColumnWidth:UIScreen.mainScreen.bounds.size.width*0.5];
    [self setMaximumPrimaryColumnWidth:UIScreen.mainScreen.bounds.size.width*0.5];
}

- (void)navigateToSettings {
    [self showDetailViewController:[[SettingsViewController alloc] init] sender:self];
}

@end
