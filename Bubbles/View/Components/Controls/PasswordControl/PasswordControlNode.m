//
//  PasswordControlNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/8/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "PasswordControlNode.h"
#import "TextControlNode_Protected.h"

@interface PasswordControlNode()<ASEditableTextNodeDelegate>
@end

@implementation PasswordControlNode
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setReturnKeyType:UIReturnKeyDone];
    }
    return self;
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self resignFirstResponder];
        return NO;
    }
    
    if (!_text) {
        _text = text;
    } else {
        NSMutableString *temp = [[NSMutableString alloc] initWithString:_text];
        if ([text isEqualToString:@""] && ([temp length] >= 1)) {
            [temp deleteCharactersInRange:NSMakeRange([temp length] - 1, 1)];
            
        }else {
            [temp appendString:text];
        }
        
        _text = temp;
    }
    
    NSInteger times = [_text length];
    char str[times + 1];
    memset(str, '*', times);
    str[times] = 0;
    
    NSString *maskedText = [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
    [editableTextNode setAttributedText:[[NSAttributedString alloc] initWithString:maskedText attributes:attributes]];
    
    if ([self onTextUpdate]) {
        [self onTextUpdate](_text);
    }
    
    return NO;
}

@end
