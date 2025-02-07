//
//  PhoneNumberControlNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "PhoneNumberControlNode.h"
@interface PhoneNumberControlNode () <UITextViewDelegate>
@end
@implementation PhoneNumberControlNode

- (NSString *)text {
    return [[super text] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)didLoad {
    [super didLoad];
    
    [[self textView] setDelegate:self];
    [[self textView] setTextContentType:UITextContentTypeTelephoneNumber];
    [self setKeyboardType:UIKeyboardTypePhonePad];
    [self setPlaceholder: @"phone_number_placeholder"];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return true;
    }
    
    NSCharacterSet* digits = [NSCharacterSet decimalDigitCharacterSet];
    if ([text rangeOfCharacterFromSet:digits].location == NSNotFound) {
        return false;
    }
        
    if ([text isEqualToString:@"\n"]) {
        return false;
    }
            
    if ([text isEqualToString:@""]) {
        return false;
    }
    
    if ([[textView text] length] >= 13) {
        return false;
    }
    
    if ([[textView text] length] == 2) {
        [textView setText:[[textView text] stringByAppendingString:text]];
        [textView setText:[[textView text] stringByAppendingString:@" "]];
        return false;
    }
    
    if ([[textView text] length] == 6) {
        [textView setText:[[textView text] stringByAppendingString:text]];
        [textView setText:[[textView text] stringByAppendingString:@" "]];
        return false;
    }
    
    
    if ([[textView text] length] == 9) {
        [textView setText:[[textView text] stringByAppendingString:text]];
        [textView setText:[[textView text] stringByAppendingString:@" "]];
        return false;
    }
    
    
    return true;
}

@end
