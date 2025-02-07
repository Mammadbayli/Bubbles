//
//  ButtonNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "ButtonNode.h"
#import "NSNumber+Dimensions.h"
#import "Constants.h"

@interface ButtonNode()
@end

@implementation ButtonNode
- (instancetype)init {
    self = [super init];
    
    if(self) {
        _text = @"";
        _textColor = [UIColor whiteColor];
        _font = [UIFont textFont];
        
        _hasShadow = YES;
        
        [[self style] setHeight:ASDimensionMake([NSNumber controlHeight])];
//        [[self style] setMaxWidth:ASDimensionMake([NSNumber controlMaxWidth])];
        
        [[self titleNode] setMaximumNumberOfLines:1];
        [[self titleNode] setTextContainerInset:UIEdgeInsetsMake(0, 5, 0, 5)];
//        [[self titleNode] setTruncationMode:NSLineBreakByWordWrapping];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languageDidChange:)
                                                     name:LANGUAGE_DID_CHANGE_NOTIFICATION
                                                   object:nil];
        
        [self setCornerRadius:10];
        
        [self setShadowColor:[[UIColor blackColor] CGColor]];
        [self setShadowOpacity:0.2];
        [self setShadowRadius:1];
        [self setShadowOffset:CGSizeMake(2, 2)];
        
        [self setContentMode:UIViewContentModeCenter];
    }
    
    return self;
}

- (void)setHasShadow:(BOOL)hasShadow {
    _hasShadow = hasShadow;
    if (hasShadow) {
        [self setShadowOpacity:0.2];
    } else {
        [self setShadowOpacity:0];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        [self setBackgroundColor:[[self backgroundColor] colorWithAlphaComponent:1]];
    } else {
        [self setBackgroundColor:[[self backgroundColor] colorWithAlphaComponent:0.2]];
    }
}

- (void)setImage:(UIImage * _Nullable)image {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setImage:image forState:UIControlStateNormal];
    [self setHasShadow:NO];
}

- (void)setText:(NSString * _Nullable)text {
    _text = text;
    [self updateText];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self updateText];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self updateText];
}

- (void)languageDidChange: (NSNotification*)notif {
    [self updateText];
}

- (void)updateText {
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] init];
    if ([self text] != nil) {
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        [pStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = @{
            NSFontAttributeName: [self font],
            NSForegroundColorAttributeName: [self textColor],
            NSParagraphStyleAttributeName: pStyle
        };
        
        
        attributedTitle = [[NSAttributedString alloc]
                                               initWithString:NSLocalizedString([self text], nil)
                                               attributes:attributes];
        
        
    }
    
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (void)setColor:(UIColor *)color {
    [self setBackgroundColor: color];
}

- (void)setOnCLick:(Event)onCLick {
    _onCLick = onCLick;
    
    if (onCLick) {
        [self addTarget:self action:@selector(click) forControlEvents:ASControlNodeEventTouchUpInside];
    } else {
        [self removeTarget:self action:@selector(click) forControlEvents:ASControlNodeEventTouchUpInside];
    }
}

- (void)click {
    if ([self onCLick]) {
        [self onCLick]();
    }
    
    //button press feedback
    [self setShadowOffset:CGSizeMake(0, 0)];
    
    typeof(self) __weak weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf setShadowOffset:CGSizeMake(2, 2)];
    }];
};

#pragma mark - Factory Methods
+ (instancetype)greenButtonWithTitle:(NSString *)title {
    ButtonNode *node = [[[self class] alloc] init];
    
    [node setColor:[UIColor greenButtonColor]];
    [node setText:title];
    
    return node;
}

+ (instancetype)orangeButtonWithTitle:(NSString *)title {
    ButtonNode *node = [[[self class] alloc] init];
    
    [node setColor:[UIColor NFSOrangeColor]];
    [node setText:title];
    
    return node;
}

+ (instancetype)buttonWithGreenTitle:(NSString *) title {
    ButtonNode *node = [[self class] buttonWithTitle:title];
    
    [node setTextColor:[UIColor NFSGreenColor]];
    
    return node;
}

+ (instancetype)buttonWithTitle:(NSString *)title {
    ButtonNode *node = [[[self class] alloc] init];
    
    [node setColor:[UIColor clearColor]];
    [node setText:title];
    [node setTextColor:[UIColor textColor]];
    [node setHasShadow:NO];
    [node setContentMode:UIViewContentModeCenter];
    
    return node;
}

+ (instancetype)buttonWithIcon:(NSString *)icon {
    ButtonNode *node = [[self class] buttonWithTitle:icon];
    [node setTextColor:[UIColor NFSGreenColor]];
    [node setFont:[UIFont NFSFont]];
    
    return node;
}

+ (instancetype)facebookButton {
    ButtonNode *node = [[[self class] alloc] init];
    [node setColor:[UIColor facebookBlueColor]];
    [node setText:@"fb_login"];
    return node;
}

@end
