//
//  OneTimeCodeTextControlNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "OneTimeCodeTextControlNode.h"
#import "UIFont+NFSFonts.h"
#import "NSNumber+Dimensions.h"
#import "UIColor+NFSColors.h"
#import "TextField.h"

@interface OneTimeCodeTextControlNode()<UITextFieldDelegate>
@property (strong, nonatomic) TextField *textField;
@end

@implementation OneTimeCodeTextControlNode
- (NSString *)text {
    return  [[self textField] text];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        typeof(self) __weak weakSelf = self;
        [self setViewBlock:^UIView * _Nonnull{
            TextField *textField = [[TextField alloc] init];
            [textField setTypingAttributes:@{NSFontAttributeName:[UIFont textFont]}];
            [textField setFont:[UIFont textFont]];
            [textField setTextContentType:UITextContentTypeOneTimeCode];
            [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"sms_code_placeholder", nil) attributes:@{
                NSForegroundColorAttributeName: [UIColor placeholderColor],
                NSFontAttributeName:[UIFont textFont]
            }]];
            //            [textField setTextAlignment:NSTextAlignmentCenter];
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            [textField setInputAccessoryView:[[UIView alloc] init]];
            [textField setDelegate:weakSelf];
            [textField addTarget:weakSelf action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
            [weakSelf setTextField:textField];
            return textField;
        }];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setClipsToBounds:YES];
        [self setCornerRadius:10];
        [[self style] setHeight:ASDimensionMake([NSNumber controlHeight])];
    }
    return self;
}

- (void)valueChanged {
    if ([self onTextUpdate]) {
        [self onTextUpdate]([self text]);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ([[self text] length] >= 4) {
        return NO;
    }
    
    //    if ([self onTextUpdate]) {
    //        [self onTextUpdate]([self text]);
    //    }
    
    return YES;
}
@end
