//
//  TextControlNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "TextControlNode.h"
#import "UIColor+NFSColors.h"
#import "UIFont+NFSFonts.h"
#import "NSNumber+Dimensions.h"
#import "Constants.h"

@interface TextControlNode()<ASEditableTextNodeDelegate>
@end

@implementation TextControlNode {
    NSString* _text;
    NSMutableDictionary *attributes;
    NSMutableParagraphStyle *pStyle;
}

- (void)alertValidationError {
    [self setBorderWidth:1];
    [self setBorderColor:[[UIColor redColor] CGColor]];
}

- (void)clearValidationError {
    [self setBorderWidth:1];
    [self setBorderColor:[[UIColor textControlBorderColor] CGColor]];
}

- (instancetype) init {
    self = [super init];
    
    if(self) {
        _lineSpacing = 1.0;
        _color = [UIColor blackColor];
        _textAlignment = NSTextAlignmentLeft;
        _font = [UIFont textFont];
        
        _shouldClearOnSubmit = NO;
        
        pStyle = [[NSMutableParagraphStyle alloc] init];
        [pStyle setLineSpacing:_lineSpacing];
        [pStyle setAlignment:_textAlignment];
        
        attributes = [[NSMutableDictionary alloc] initWithDictionary:@{
            NSForegroundColorAttributeName: _color,
            NSParagraphStyleAttributeName: pStyle,
            NSFontAttributeName: _font
        }];
        
        [self setCornerRadius:10];
        [self setTypingAttributes:@{NSFontAttributeName:[UIFont textFont]}];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setClipsToBounds:YES];
        [self setMaximumLinesToDisplay:1];
        [self setScrollEnabled:NO];
        [self setTextContainerInset:UIEdgeInsetsMake(12, 8, 12, 8)];
        [[self style] setHeight:ASDimensionMake([NSNumber controlHeight])];
        [self setEnablesReturnKeyAutomatically:YES];
        
        [self setDelegate:self];
        
        [self clearValidationError];
    }
    
    return self;
}

-(void)didLoad {
    [super didLoad];
    
    [[self textView] setInputAccessoryView: [[UIView alloc] init]];
}

- (void)setAttribute: (NSObject*)attribute withName:(NSString*)attributeName {
    attributes[attributeName] = attribute;
    
    [self setTypingAttributes:attributes];
    [self updateText];
}

- (void)setText:(NSString * _Nullable)text {
    _text = text;
    [self updateText];
}

- (NSString *)text {
    return _text;
}

- (void)setFont:(UIFont *)font {
    _font = font;

    [self setAttribute:font withName:NSFontAttributeName];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    [self setAttribute:color withName:NSForegroundColorAttributeName];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    
    [pStyle setAlignment:textAlignment];
    [self setAttribute:pStyle withName:NSParagraphStyleAttributeName];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    
    [pStyle setAlignment:lineSpacing];
    [self setAttribute:pStyle withName:NSParagraphStyleAttributeName];
}

- (void)updateText {
    if ([self text]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:[self text] attributes: attributes];
        
        [self setAttributedText: attributedText];
    } else {
        [self setAttributedText: nil];
    }
    
    if ([self onTextUpdate]) {
        [self onTextUpdate](_text);
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSDictionary *placeholderAttributes = [attributes mutableCopy];
    [placeholderAttributes setValue:[UIColor placeholderColor] forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *text = [[NSAttributedString alloc]
                                initWithString:NSLocalizedString(placeholder, nil)
                                attributes:placeholderAttributes];
    
    [self setAttributedPlaceholderText:text];
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([[self textControlNodeDelegate] respondsToSelector:@selector(onSubmitText:)]) {
            [[self textControlNodeDelegate] onSubmitText:[self text]];
            if([self shouldClearOnSubmit]) {
                [self setText:nil];
            }
        }
        
        [self resignFirstResponder];
    }
    
    return YES;
}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode {
    _text = [[editableTextNode attributedText] string];
    
    if ([self onTextUpdate]) {
        [self onTextUpdate](_text);
    }
    
    if ([[self textControlNodeDelegate] respondsToSelector:@selector(textControlNodeDidUpdateText:)]) {
        [[self textControlNodeDelegate] textControlNodeDidUpdateText:self];
    }
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode {
    if ([[self textControlNodeDelegate] respondsToSelector:@selector(textControlNodeDidBeginEditing:)]) {
        [[self textControlNodeDelegate] textControlNodeDidBeginEditing:self];
    }
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode {
    if ([[self textControlNodeDelegate] respondsToSelector:@selector(textControlNodeDidFinishEditing:)]) {
        [[self textControlNodeDelegate] textControlNodeDidFinishEditing:self];
    }
}

@end
