//
//  WithLogoViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/1/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "WithLogoViewController.h"
#import "UIColor+NFSColors.h"
#import "NSNumber+Dimensions.h"

@interface WithLogoViewController ()
@end

@implementation WithLogoViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        _containerNode = [[ASDisplayNode alloc] init];
        [_containerNode setAutomaticallyManagesSubnodes:YES];
        [[_containerNode style] setMaxWidth:ASDimensionMake([NSNumber controlMaxWidth])];
        
        typeof(self) __weak weakSelf = self;
        [[super node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            [[[weakSelf containerNode] style] setHeight:ASDimensionMake(constrainedSize.max.height*(1 - [NSNumber logoTopDistanceFactor]))];
            [[[weakSelf containerNode] style] setWidth: ASDimensionMake(constrainedSize.max.width*[NSNumber widthFactor])];
            ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, INFINITY, 0, INFINITY)
                                                                                    child:[weakSelf containerNode]];
            
            return insetLayout;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [logoImageView setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self view] addSubview:logoImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [[logoImageView centerXAnchor] constraintEqualToAnchor:[[[self view] safeAreaLayoutGuide] centerXAnchor]],
        [[logoImageView widthAnchor] constraintLessThanOrEqualToAnchor:[[[self view] safeAreaLayoutGuide] widthAnchor]],
        [[logoImageView heightAnchor] constraintLessThanOrEqualToConstant:250],
        [[logoImageView centerYAnchor] constraintEqualToAnchor:[[[self view] safeAreaLayoutGuide] centerYAnchor] constant:-[[self view] frame].size.height*[NSNumber logoTopDistanceFactor]],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    //    [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-message"] selectedImage:nil]];
}
@end
