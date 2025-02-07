//
//  TableCellNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "TableCellNode.h"
#import "NSNumber+Dimensions.h"

@interface TableCellNode ()
@end

@implementation TableCellNode
- (TextNode *)titleNode {
    if (!_titleNode) {
        _titleNode = [[TextNode alloc] init];
        
        [_titleNode setTextContainerInset: UIEdgeInsetsMake(0, [NSNumber tableCellLateralPadding], 0, 0)];
        [_titleNode setMaximumNumberOfLines:1];
        [_titleNode setFont:[UIFont tableCellTextFont]];
        [_titleNode setZPosition:100];
        [_titleNode setLayerBacked:YES];
    }
    
    return  _titleNode;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
        [[self style] setMinHeight:ASDimensionMake([NSNumber tableCellMinHeight])];
        
        typeof(self) __weak weakSelf = self;
//        [self setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
//            NSMutableArray *children = [[NSMutableArray alloc] initWithArray:@[[weakSelf titleNode]]];
//
//            float titleNodeFlexBasis = 1;
//
//            if ([weakSelf leftNode]) {
//                titleNodeFlexBasis -= [[[weakSelf leftNode] style] flexBasis].value;
//                [children insertObject:[weakSelf leftNode] atIndex:0];
//            }
//
//            if ([weakSelf rightNode]) {
//                titleNodeFlexBasis -= [[[weakSelf rightNode] style] flexBasis].value;
//                [children addObject:[weakSelf rightNode]];
//            }
//
//            [[[weakSelf titleNode] style] setFlexBasis:ASDimensionMake(ASDimensionUnitFraction, titleNodeFlexBasis)];
//
//            ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
//                                                                                   spacing:0
//                                                                            justifyContent:ASStackLayoutJustifyContentStart
//                                                                                alignItems:ASStackLayoutAlignItemsCenter
//                                                                                  children:children];
//
//            UIEdgeInsets insets = UIEdgeInsetsMake(0, [NSNumber tableCellLateralPadding], 0, [NSNumber tableCellLateralPadding]);
//            ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:stack];
//            return insetLayout;
//        }];
        
//        [self setSeparatorInset:UIEdgeInsetsMake(0, [NSNumber tableCellLateralPadding], 0, [NSNumber tableCellLateralPadding])];
        [self setAutomaticallyManagesSubnodes: YES];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSMutableArray *children = [[NSMutableArray alloc] initWithArray:@[[self titleNode]]];
    
    float titleNodeFlexBasis = 1;
    
    if ([self leftNode]) {
        titleNodeFlexBasis -= [[[self leftNode] style] flexBasis].value;
        [children insertObject:[self leftNode] atIndex:0];
    }
    
    if ([self rightNode]) {
        titleNodeFlexBasis -= [[[self rightNode] style] flexBasis].value;
        [children addObject:[self rightNode]];
    }
    
    [[[self titleNode] style] setFlexBasis:ASDimensionMake(ASDimensionUnitFraction, titleNodeFlexBasis)];
    
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                       spacing:0
                                                                justifyContent:ASStackLayoutJustifyContentStart
                                                                    alignItems:ASStackLayoutAlignItemsCenter
                                                                      children:children];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, [NSNumber tableCellLateralPadding], 0, [NSNumber tableCellLateralPadding]);
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:stack];
    return insetLayout;
}

- (ASNetworkImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASNetworkImageNode alloc] init];
        [_imageNode setContentMode:UIViewContentModeScaleAspectFit];
        [_imageNode setLayerBacked:YES];
        [_imageNode setClipsToBounds:YES];
        
        ASRatioLayoutSpec *imageRatio = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:_imageNode];
        [[imageRatio style] setFlexBasis:ASDimensionMake(@"13%")];

        [self setLeftNode: imageRatio];
    }
    
    return _imageNode;
}

- (void)setImage:(UIImage*)image {
    [[self imageNode] setURL:nil];
    [[self imageNode] setImage:image];
}

- (void)setImageURL:(NSURL *)imageURL {
    [[self imageNode] setImage:nil];
    [[self imageNode] setURL:imageURL];
}

- (void)setTitle:(NSString*)title {
    _title = title;
    [[self titleNode] setText:title];
}

- (void)setRightNode:(id<ASLayoutElement>)rightNode {
    _rightNode = rightNode;
    [self setNeedsLayout];
}
@end
