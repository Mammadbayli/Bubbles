//
//  UserSupportViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "UserSupportViewController.h"
#import "TextControlNode.h"
#import "ButtonNode.h"
#import "TextNode.h"
#import "UIColor+NFSColors.h"
#import "UserSupportController.h"
#import "AlertPresenter.h"


@interface UserSupportViewController ()
@property (strong, nonatomic) TextControlNode *textControlNode;
@property (strong, nonatomic) ButtonNode *buttonNode;
@property (strong, nonatomic) TextNode *textNode;
@end

@implementation UserSupportViewController
- (TextControlNode *)textControlNode {
    if (!_textControlNode) {
        _textControlNode = [[TextControlNode alloc] init];
        
        typeof(self) __weak weakSelf = self;
        [_textControlNode setOnTextUpdate:^(NSString * _Nonnull text) {
            if ([text length]) {
                [[weakSelf buttonNode] setEnabled:YES];
            } else {
                [[weakSelf buttonNode] setEnabled:NO];
            }
        }];
    }
    
    return _textControlNode;
}

- (ButtonNode *)buttonNode {
    if (!_buttonNode) {
        _buttonNode = [ButtonNode greenButtonWithTitle:@"send"];
        [_buttonNode setEnabled:NO];
        
        typeof(self) __weak weakSelf = self;
        [_buttonNode setOnCLick:^{
            [[UserSupportController sharedInstance] sendTicket:[[weakSelf textControlNode] text]]
            .then(^{
                [[weakSelf textControlNode] setText:nil];
                [[AlertPresenter sharedInstance] presentWithTitle:@"" message:@"success"];
            });
        }];
    }
    
    return _buttonNode;
}

- (TextNode *)textNode {
    if (!_textNode) {
        _textNode = [[TextNode alloc] init];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"or_contact_us", nil) attributes:@{
            NSForegroundColorAttributeName: [UIColor NFSGreenColor],
            NSParagraphStyleAttributeName: paragraphStyle
        }];
        
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"\n(+994) 000 00 00" attributes:@{
            NSForegroundColorAttributeName: [UIColor textColor],
            NSParagraphStyleAttributeName: paragraphStyle
        }];
        
        [attributedText appendAttributedString: text];
        
        [_textNode setAttributedText:attributedText];
    }
    
    return _textNode;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setNavTitle:@"settings_support"];
        
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        typeof(self) __weak weakSelf = self;
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            [[[weakSelf textControlNode] style] setHeight:ASDimensionMake(constrainedSize.max.height*0.3)];
            [[[weakSelf textControlNode] style] setMinWidth:ASDimensionMake(constrainedSize.max.width*0.9)];
            
            [[[weakSelf textControlNode] style] setSpacingBefore:20];
            [[[weakSelf textNode] style] setSpacingBefore:20];
            
            [[[weakSelf buttonNode] style] setWidth:ASDimensionMake(80)];
            
            return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                           spacing:10
                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                          children:@[[weakSelf textControlNode], [weakSelf buttonNode], [weakSelf textNode]]];
        }];
    }
    
    return self;
}

@end
