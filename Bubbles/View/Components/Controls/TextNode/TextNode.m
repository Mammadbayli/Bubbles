//
//  TextNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/6/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "TextNode.h"
#import "UIColor+NFSColors.h"
#import "UIFont+NFSFonts.h"
#import "Constants.h"

@implementation TextNode {
    NSAttributedString *_attr;
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        _font = [UIFont textFont];
        _color = [UIColor textColor];
        _textAlignment = NSTextAlignmentLeft;
        _attr = nil;
        
        [self setAttributedText:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languageDidChange:)
                                                     name:LANGUAGE_DID_CHANGE_NOTIFICATION
                                                   object:nil];
    }
    
    return self;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    [self updateText];
}

-(void)setText:(NSString *)text {
    _text = text;
    [self updateText];
}

-(void)setColor:(UIColor *)color {
    _color = color;
    [self updateText];
}

-(void)setFont:(UIFont *)font {
    _font = font;
    [self updateText];
}

-(void)languageDidChange: (NSNotification*)notif {
    [self updateText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attr = attributedText;
    [super setAttributedText:attributedText];
}

- (void)updateText {
    if (_attr == nil) {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = _textAlignment;
        
        NSAttributedString *text = [[NSAttributedString alloc] initWithString: NSLocalizedString([self text], nil)
                                                                   attributes:@{
                                                                       NSForegroundColorAttributeName: [self color],
                                                                       NSFontAttributeName: [self font],
                                                                       NSParagraphStyleAttributeName:paragraphStyle
                                                                   }];
        
        [super setAttributedText:text];
    }

}

+ (instancetype)textWithIcon:(NSString*)icon {
    TextNode *node = [[[self class] alloc] init];
    [node setFont:[UIFont NFSFont]];
    [node setText:icon];
    
    return node;
}

@end
