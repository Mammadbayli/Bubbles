//
//  ViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+NFSColors.h"
#import "UIFont+NFSFonts.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController
- (instancetype)init {
    self = [super initWithNode:[[ASDisplayNode alloc] init]];
    
    if (self) {
        [self setupNode];
    }
    
    return self;
}

- (instancetype)initWithNode:(ASDisplayNode *)node {
    self = [super initWithNode:node];
    
    if (self) {
        [self setupNode];
        _navColor = [UIColor backgroundColor];
    }
    
    return self;
}

- (void)setupNode {
    [[self node] setAutomaticallyManagesSubnodes:YES];
    [[self node] setBackgroundColor:[UIColor backgroundColor]];
    [[self node] setAutomaticallyRelayoutOnSafeAreaChanges:YES];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideKeyboard)];
    [recognizer setCancelsTouchesInView:NO];
    [[self view] addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(languageDidChange)
                                                 name:LANGUAGE_DID_CHANGE_NOTIFICATION
                                               object:nil];
}

- (void)languageDidChange {
    [[[[self navigationItem] searchController] searchBar] setPlaceholder:NSLocalizedString(@"search", nil)];
    
    if (![self navSubtitle]) {
        [self setNavTitle:[self navTitle]];
    } else {
        [self setNavTitle:[self navTitle] subtitle:[self navSubtitle]];
    }
}

- (void)hideKeyboard {
    [[self view] endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

}

- (void)setNavTitle:(NSString *)title {
    _navTitle = title;
    
    typeof(self) __weak weakSelf = self;
    dispatch_block_t onMain = ^{
        [[weakSelf navigationItem] setTitle:NSLocalizedString(title, nil)];
        
        [[[weakSelf navigationController] navigationBar] setLargeTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationSmallTitleFont]
        }];
        
        [[weakSelf navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    };
    
    if ([NSThread isMainThread]) {
        onMain();
    } else {
        dispatch_async(dispatch_get_main_queue(), onMain);
    }
}

- (void)setNavTitle:(NSString *)title subtitle:(NSString *)subtitle {
    _navTitle = title;
    _navSubtitle = subtitle;
    
    NSMutableAttributedString *titleString;
    
    if(title) {
        titleString = [[NSMutableAttributedString alloc]
                       initWithString:title
                       attributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSFontAttributeName: [UIFont navigationSmallTitleFont]
        }];
    }
    
    if(subtitle) {
        NSMutableAttributedString *subtitleString;
        subtitleString = [[NSMutableAttributedString alloc]
                          initWithString:NSLocalizedString(subtitle, nil)
                          attributes:@{
            NSForegroundColorAttributeName: [UIColor lighterTextColor],
            NSFontAttributeName: [UIFont navigationSubtitleFont]
        }];
        
        [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [titleString appendAttributedString:subtitleString];
    }
    
    typeof(self) __weak weakSelf = self;
    dispatch_block_t onMain = ^{
        // update UI code here
        [[[weakSelf navigationController] navigationBar] setPrefersLargeTitles:NO];
        [[weakSelf navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
        
        UILabel *label = [[UILabel alloc] init];
        
        [label setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [label setNumberOfLines:2];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setAttributedText:titleString];
        
        [[weakSelf navigationItem] setTitleView:label];
    };
    
    if ([NSThread isMainThread]) {
        onMain();
    } else {
        dispatch_async(dispatch_get_main_queue(), onMain);
    }
}

@end
