//
//  LicensePlateNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/2/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "LicensePlateControlNode.h"
#import "UIFont+NFSFonts.h"
#import "NSNumber+Dimensions.h"

@interface LicensePlateControlNode()<ASEditableTextNodeDelegate>
@end

@implementation LicensePlateControlNode
#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setFont:[UIFont licensePlateFont]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setPlaceholder:@"00-HH-000"];
        
        [[self style] setMaxWidth:ASDimensionMake(200)];
        
        [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [self setTextContainerInset:UIEdgeInsetsMake(4, 30, 4, 6)];

        [self setAutomaticallyManagesSubnodes:YES];
        
#pragma mark - Flag Node
        ASImageNode *flagNode = [[ASImageNode alloc] init];
        [flagNode setBackgroundColor: [UIColor greenColor]];
        [flagNode setImage:[UIImage imageNamed:@"flag-license-plate"]];
        [flagNode setLayerBacked:YES];
        [[flagNode style] setPreferredSize: CGSizeMake(15, 8)];
        
#pragma mark - Text Node
        ASTextNode *textNode = [[ASTextNode alloc] init];
        [textNode setLayerBacked:YES];
        [textNode setBorderWidth:1];
        [[textNode style] setPreferredSize:CGSizeMake(15, 15)];
        [textNode setTextContainerInset:UIEdgeInsetsMake(2, 1, 1, 1)];
        [textNode setCornerRadius:4];
        [textNode setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [textNode setAttributedText:[[NSAttributedString alloc] initWithString:@"AZ"
                                                                    attributes:@{
                                                                        NSFontAttributeName: [UIFont systemFontOfSize:9],
                                                                        NSForegroundColorAttributeName: [UIColor lightGrayColor]
                                                                    }]];
        
        [flagNode setZPosition:999];
        [textNode setZPosition:999];
        
        [self setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                spacing:4
                                                                         justifyContent:ASStackLayoutJustifyContentCenter
                                                                             alignItems:ASStackLayoutAlignItemsCenter
                                                                               children:@[flagNode, textNode]];
            
            ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 10, 0, 0)
                                                                                    child:stackLayout];
            ASLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart
                                                                                                 verticalPosition:ASRelativeLayoutSpecPositionStart
                                                                                                     sizingOption:ASRelativeLayoutSpecSizingOptionDefault
                                                                                                            child:insetLayout];
            
            return relativeLayout;
        }];
    }
    
    return self;
}

- (NSString *)licensePlateNumber {
    if ([[self text] length] == 9) {
        return [[self text] lowercaseString];
    }
    
    return nil;
}

- (void)setLicensePlateNumber:(NSString *)licensePlateNumber {
    [self setText:[licensePlateNumber uppercaseString]];
}

//- (void)setText:(NSString *)text {
//    [super setText:[text uppercaseString]];
//    
//    [[self delegate] editableTextNodeDidUpdateText:self];
//}
//
//- (NSString *)text {
//    return [[super text] lowercaseString];
//}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode {
    if ([[self textControlNodeDelegate] respondsToSelector:@selector(textControlNodeDidUpdateText:)]) {
          [[self textControlNodeDelegate] textControlNodeDidUpdateText:self];
      }
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *currentText = [[editableTextNode attributedText] string];
    
    if ([text isEqualToString:@""]) {
        if ([currentText length] > 0) {
            [self setText:[currentText substringToIndex:[currentText length] - 1]];
        } else {
            //no characters to delete... attempting to do so will result in a crash
        }
        return NO;
    }
    
    if ( [text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if ([currentText length] > 8) {
        return NO;
    }
    
    if ( [text isEqualToString:@" "]) {
        return NO;
    }
    
    if ([currentText length] == 0) {//0 0-HH-000
        NSRange first = [text rangeOfComposedCharacterSequenceAtIndex:0];
        NSRange match = [text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:0 range:first];
        if (match.location != NSNotFound) {
             [self setText:text];
        }
        
        return NO;
    }
    
    if ([currentText length] == 1) {//0 0 -HH-000
        if ([currentText isEqualToString:@"1"] && [text isEqualToString:@"3"]) {//13 is not a valid area code
            return NO;
        }
        
        if ([currentText isEqualToString:@"0"] && [text isEqualToString:@"0"]) {//00 is not a valid area code
            return NO;
        }
        
        NSRange first = [text rangeOfComposedCharacterSequenceAtIndex:0];
        NSRange match = [text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:0 range:first];
        if (match.location != NSNotFound) {
            [self setText:[currentText stringByAppendingString:[text stringByAppendingString:@"-"]]];
        }
        
        return NO;
    }
    
    if ([currentText length] == 3) {//00- H H-000
        NSRange first = [text rangeOfComposedCharacterSequenceAtIndex:0];
        NSRange match = [text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:0 range:first];
        if (match.location != NSNotFound) {
            [self setText:[currentText stringByAppendingString:[text uppercaseString]]];
        }
        
        return NO;
    }
    
    if ([currentText length] == 4) {//00-H H -000
        NSRange first = [text rangeOfComposedCharacterSequenceAtIndex:0];
        NSRange match = [text rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:0 range:first];
        if (match.location != NSNotFound) {
            [self setText:[currentText stringByAppendingString:[[text uppercaseString] stringByAppendingString:@"-"]]];
        }
        
        return NO;
    }
    
    if ([currentText length] >= 4) {
        NSRange first = [text rangeOfComposedCharacterSequenceAtIndex:0];
        NSRange match = [text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:0 range:first];
        if (match.location != NSNotFound) {
            [self setText:[currentText stringByAppendingString:text]];
        }
        
        return NO;
    }
    
    return NO;
}
@end
