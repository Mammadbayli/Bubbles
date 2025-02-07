//
//  NavigationController.m
//  Bubbles
//
//  Created by Javad on 13.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "NavigationController.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"

@interface NavigationController ()
@property (nonatomic) BOOL isPresentingActivityIndicator;
@end

@implementation NavigationController

- (void)setupNavigationBar {
    if (@available(iOS 13, *)){
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        
        [appearance setBackgroundColor:[UIColor lightBackgroundColor]];
//        [appearance setShadowImage:[UIImage new]];
//        [appearance setShadowColor:[UIColor clearColor]];
        [appearance setLargeTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationTitleFont]
        }];
        [appearance setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationSmallTitleFont]
        }];
        
        //        [appearance setBackgroundColor:[UIColor lighterBackgroundColor]];
        
        self.navigationBar.standardAppearance = appearance;
        
        
        UINavigationBarAppearance *scrollEdgeAppearance = [[UINavigationBarAppearance alloc] init];
        [scrollEdgeAppearance configureWithOpaqueBackground];
        [scrollEdgeAppearance setBackgroundColor:[self navColor]];
        [scrollEdgeAppearance setShadowImage:[UIImage new]];
        [scrollEdgeAppearance setShadowColor:[UIColor clearColor]];
        [scrollEdgeAppearance setLargeTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationTitleFont]
        }];
        [scrollEdgeAppearance setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationSmallTitleFont]
        }];
        
        self.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance;
        
        UINavigationBarAppearance *compactAppearance = [[UINavigationBarAppearance alloc] init];
        [compactAppearance configureWithOpaqueBackground];
        [compactAppearance setBackgroundColor:[UIColor lightBackgroundColor]];
//        [compactAppearance setShadowImage:[UIImage new]];
//        [compactAppearance setShadowColor:[UIColor clearColor]];
        [compactAppearance setLargeTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationTitleFont]
        }];
        [compactAppearance setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationSmallTitleFont]
        }];
        
        self.navigationBar.compactAppearance = compactAppearance;
    }
    
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor backgroundColor]];
    [self.navigationBar setTranslucent:YES];
//    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTintColor:[UIColor NFSGreenColor]];
    [self.navigationBar setPrefersLargeTitles:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
}

- (void)setNavColor:(UIColor *)navColor {
    _navColor = navColor;
    
    [self setupNavigationBar];
}

- (void)showActivityIndicator {
    if (![self isPresentingActivityIndicator]) {
        dispatch_block_t onMain = ^{
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
            [[[[self navigationBar] items] firstObject] setTitleView:activityView];
            
            [activityView startAnimating];
            [self setIsPresentingActivityIndicator:YES];
        };
        
        if ([NSThread isMainThread]) {
            onMain();
        } else {
            dispatch_async(dispatch_get_main_queue(), onMain);
        }
    }
}

- (void)hideActivityIndicator {
    if ([self isPresentingActivityIndicator]) {
        dispatch_block_t onMain = ^{
            [[[[self navigationBar] items] firstObject] setTitleView:nil];
            [self setIsPresentingActivityIndicator:NO];
        };
        
        if ([NSThread isMainThread]) {
            onMain();
        } else {
            dispatch_async(dispatch_get_main_queue(), onMain);
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navColor = [UIColor backgroundColor];
        [self setupNavigationBar];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        _navColor = [UIColor backgroundColor];
        [self setupNavigationBar];
    }
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
