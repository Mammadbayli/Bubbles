//
//  AccountCellNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/6/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "AccountCellNode.h"
#import "TextNode.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"
#import "NSNumber+Dimensions.h"

@interface AccountCellNode()<ASEditableTextNodeDelegate>
@property (strong, nonatomic) TextNode *privacyControlNode;
@property (strong, nonatomic) TextNode *titleTextNode;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) ASEditableTextNode *valueEditableNode;
@property (nonatomic) BOOL isVisible;
@property (strong, nonatomic) UserAttribute *attribute;
@end

@implementation AccountCellNode{
    BOOL _isEditable;
    double padding;
}

- (void)setIsVisible:(BOOL)isVisible {
    [_attribute setIsVisible:isVisible];
    
    NSString *text = isVisible ? @"\uea06" : @"\uea07";
    [[self privacyControlNode] setText:text];
}

- (BOOL)isVisible {
    return [_attribute isVisible];
}

- (TextNode *)privacyControlNode {
    if(!_privacyControlNode) {
        _privacyControlNode = [[TextNode alloc] init];
        [_privacyControlNode setZPosition:100];
        [_privacyControlNode setTextAlignment:NSTextAlignmentRight];
        [_privacyControlNode setFont:[[UIFont NFSFont] fontWithSize:30]];
        [_privacyControlNode setText:@"\uea06"];
        [_privacyControlNode addTarget:self action:@selector(toggleVisibility:) forControlEvents:ASControlNodeEventTouchUpInside];
        [[_privacyControlNode style] setFlexBasis:ASDimensionMake(@"12%")];
        [[_privacyControlNode style] setHeight:ASDimensionMake(25)];
        NSString *text = [self isVisible] ? @"\uea06" : @"\uea07";
        [_privacyControlNode setText:text];
        [_privacyControlNode setColor:[UIColor NFSGreenColor]];
    }
    
    return _privacyControlNode;
}

- (TextNode *)titleTextNode {
    if (!_titleTextNode) {
        _titleTextNode = [[TextNode alloc] init];
        [_titleTextNode setColor:[UIColor lightTextColor]];
        [_titleTextNode setFont:[UIFont accountAttributeTitleFont]];
        [_titleTextNode setTextAlignment:NSTextAlignmentLeft];
        [_titleTextNode setText:[NSString stringWithFormat:@"user_%@", _title]];
    }
    
    return _titleTextNode;
}

- (ASEditableTextNode *)valueEditableNode {
    if (!_valueEditableNode) {
        _valueEditableNode = [[ASEditableTextNode alloc] init];
        [_valueEditableNode setMaximumLinesToDisplay:INFINITY];
        [_valueEditableNode setDelegate:self];
        [_valueEditableNode setUserInteractionEnabled:_isEditable];
        [[_valueEditableNode style] setMinHeight:ASDimensionMake(25)];
        [[_valueEditableNode style] setFlexGrow:1];
        [_valueEditableNode setTextContainerInset:UIEdgeInsetsMake(3, 0, 3, 0)];
        
        [_valueEditableNode setTypingAttributes:@{
            NSFontAttributeName: [UIFont accountAttributeSubtitleFont],
            NSForegroundColorAttributeName: [UIColor textColor]
        }];
        
        if (_attribute) {
            NSString *visibleValue = [_attribute value];
            
            if (!_isEditable) {
                visibleValue = [_attribute isVisible] ? [_attribute value] : @"▒▒▒";
            }
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:visibleValue ?: @""
                                                                                   attributes:[_valueEditableNode typingAttributes]];
            
            [[self valueEditableNode] setAttributedText:attributedString];
        }
    }
    
    return _valueEditableNode;
}

- (instancetype)initWithAttribute:(UserAttribute *)attribute andTitle:(NSString *)title andIsEditable:(BOOL)isEditable {
    self = [super init];
    if (self) {
        _shouldRound = -1;
        _isEditable = isEditable;
        _attribute = attribute;
        _title = title;
        
        [self setAutomaticallyManagesSubnodes:YES];
        
        padding = [NSNumber tableCellLateralPadding] + 4;
//        [self setSeparatorInset:UIEdgeInsetsMake(padding, padding, padding, padding)];
    }
    
    return self;
}

//- (void)layoutDidFinish {
//    [super layoutDidFinish];
//
//    CGFloat cornerRadius = 15;
//
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//
//    CGRect bounds = CGRectInset(self.bounds, [NSNumber tableCellLateralPadding], 0);
//
//    if ([self shouldRound] == 0) {
//        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//    } else if ([self shouldRound] == 1) {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//
//    } else if ([self shouldRound] == 2) {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//    } else {
//        CGPathAddRect(pathRef, nil, bounds);
//    }
//
//    layer.path = pathRef;
//    CFRelease(pathRef);
//
//    [layer setFillColor:[UIColor whiteColor].CGColor];
//    [[self layer] insertSublayer:layer atIndex:0];
//}

- (void)toggleVisibility:(TextNode *)sender {
    [self setIsVisible:![self isVisible]];
    [self update];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *verticalStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                               spacing:0
                                                                        justifyContent:ASStackLayoutJustifyContentCenter
                                                                            alignItems:ASStackLayoutAlignItemsStretch
                                                                              children:@[[self titleTextNode], [self valueEditableNode]]];
    [[verticalStack style] setFlexBasis:ASDimensionMake(@"80%")];
    
    NSMutableArray *children = [NSMutableArray arrayWithArray:@[verticalStack]];
    if (_isEditable) {
        [children addObject:[self privacyControlNode]];
    }
    
    ASStackLayoutSpec *horizontalStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                 spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                          justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                              alignItems:ASStackLayoutAlignItemsCenter
                                                                                children:children];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, padding, 5, padding) child:horizontalStack];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode {
    [self update];
}

- (void)update {
    if([self onUpdate]) {
         NSString *text = [[[[self valueEditableNode] attributedText] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         [self onUpdate](text, [self isVisible]);
     }
}

@end
