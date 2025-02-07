//
//  PostActionNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 10/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "PostActionNode.h"
#import "TextNode.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"

@implementation PostActionNode
- (void)setLabel:(NSString *)label {
    _label = label;
    [self updateLabelAndIcon];
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    [self updateLabelAndIcon];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updateLabelAndIcon];
}

- (instancetype)initWith:(NSString *)icon AndText:(NSString *)label {
    _icon = icon;
    _label = label;
    _fontSize = 16.0;
    
    self = [super init];
    if(self) {
        [self updateLabelAndIcon];
    }
    return self;
}

- (void)updateLabelAndIcon {
    NSMutableAttributedString *iconAttrinutedString = [[NSMutableAttributedString alloc] initWithString:[self icon] attributes:@{
        NSFontAttributeName: [[UIFont icomoonFont] fontWithSize:[self fontSize]],
        NSForegroundColorAttributeName: [UIColor NFSGreenColor]
    }];
    
    [iconAttrinutedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString([self label], nil) attributes:@{
        NSFontAttributeName: [[UIFont textFont] fontWithSize:[self fontSize]],
        NSForegroundColorAttributeName: [UIColor lightTextColor]
    }];
    
    [iconAttrinutedString appendAttributedString:textAttributedString];
    
    [self setAttributedText:iconAttrinutedString];
}

- (void)setOnTap:(PostActionTapEvent)onTap {
    _onTap = onTap;
    
    if (onTap) {
        [self addTarget:self action:@selector(tapped:) forControlEvents:ASControlNodeEventTouchUpInside];
    } else {
        [self removeTarget:self action:@selector(tapped:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
}

- (void)tapped:(PostActionNode *)node {
    if ([self onTap]) {
        [self onTap](self);
    }
}
@end
