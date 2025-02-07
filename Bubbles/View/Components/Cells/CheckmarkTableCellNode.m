//
//  CheckmarkTableCellNode.m
//  Bubbles
//
//  Created by Javad on 11.02.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "CheckmarkTableCellNode.h"
#import "TextNode.h"

@interface CheckmarkTableCellNode()

@end

@implementation CheckmarkTableCellNode
- (TextNode *)checkMarkNode {
    if (!_checkMarkNode) {
        _checkMarkNode = [TextNode textWithIcon:@""];
        [[_checkMarkNode style] setFlexBasis:ASDimensionMake(@"10%")];
        [_checkMarkNode setColor:[UIColor NFSGreenColor]];
        
        [self setRightNode: _checkMarkNode];
    }
    
    return _checkMarkNode;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [[self checkMarkNode] setText:(selected ? @"\uea10" : nil)];
}
@end
