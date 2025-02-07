//
//  AlertViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/5/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "AlertViewController.h"
#import "TextNode.h"
#import "NSNumber+Dimensions.h"
#import "UIColor+NFSColors.h"
#import "ButtonNode.h"
#import "AlertViewControllerAction.h"

@interface AlertViewController ()
@property (strong, nonatomic) ASImageNode *imageNode;
@property (strong, nonatomic) TextNode *textNode;
@property (strong, nonatomic) ASScrollNode *contentNode;
@property (strong, nonatomic) NSMutableArray *actions;
@end

@implementation AlertViewController
- (TextNode *)textNode {
    if (!_textNode) {
        _textNode = [[TextNode alloc] init];
        [_textNode setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _textNode;
}
- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASImageNode alloc] init];
    }
    
    return _imageNode;
}

- (ASScrollNode *)contentNode {
    if (!_contentNode) {
        _contentNode = [[ASScrollNode alloc] init];
        [_contentNode setAutomaticallyManagesSubnodes:YES];
        [[_contentNode view] setShowsVerticalScrollIndicator:NO];
        [_contentNode setCornerRadius:10];
        [[_contentNode style] setMaxWidth:ASDimensionMake(300)];
        [[_contentNode style] setMinWidth:ASDimensionMake(150)];
        [_contentNode setBackgroundColor:[UIColor whiteColor]];
        [_contentNode setScrollableDirections:ASScrollDirectionUp|ASScrollDirectionDown];
        [[_contentNode view] setAlwaysBounceHorizontal:NO];
        
        typeof(self) __weak weakSelf = self;
        [_contentNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASStackLayoutSpec *buttonStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                           spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                                    justifyContent:ASStackLayoutJustifyContentSpaceAround
                                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                                          children:[weakSelf actions]];
            
            ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                     spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                              justifyContent:ASStackLayoutJustifyContentStart
                                                                                  alignItems:ASStackLayoutAlignItemsStretch
                                                                                    children:@[[weakSelf imageNode], [weakSelf textNode], buttonStackLayout]];
            
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20, 20, 20, 20) child:stackLayout];
        }];
        
    }
    
    return _contentNode;
}

- (instancetype)init {
    self = [super initWithNode:[[ASDisplayNode alloc] init]];
    
    if (self) {
        [[self node] setAutomaticallyManagesSubnodes:YES];
        [[self node] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        
        _actions = [[NSMutableArray alloc] init];
        
        typeof(self) __weak weakSelf = self;
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            [[[weakSelf contentNode] style] setMaxHeight:ASDimensionMake(constrainedSize.max.height*0.8)];
            
            return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                              sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                      child:[weakSelf contentNode]];
        }];
    }
    return self;
}

- (void)addAction:(AlertViewControllerAction *)action {
    ButtonNode *button;
    switch ([action style]) {
        case AlertViewControllerActionStyleDestructive:
        {
            button = [ButtonNode orangeButtonWithTitle:[action title]];
            break;
        }
            
        default:
        {
            button = [ButtonNode greenButtonWithTitle:[action title]];
            break;
        }
    }
    
    typeof(self) __weak weakSelf = self;
    [button setOnCLick:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [action handler]();
        }];
    }];
    
    [[button style] setFlexGrow:1];
    
    [[self actions] addObject:button];
}

- (void)setMessage:(NSString *)message {
    [[self textNode] setText:message];
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    [[self textNode] setAttributedText:attributedMessage];
}

- (void)setImage:(UIImage *)image {
    if (image) {
        [[self imageNode] setImage:image];
        [[[self imageNode] style] setMinHeight:ASDimensionMake(140)];
    }
}

- (void)viewDidLayoutSubviews {
    CGFloat imageHeight = [[self imageNode] frame].size.height;
    CGFloat textHeight = [[self textNode] frame].size.height;
    CGFloat buttonHeight = [NSNumber controlHeight];
    CGFloat totalHeight = imageHeight + textHeight + buttonHeight;
    
    [[[self contentNode] view] setContentSize:CGSizeMake([[self contentNode] frame].size.width, totalHeight + 70)];
}

@end
