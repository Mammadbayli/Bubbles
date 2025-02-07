//
//  TableCellNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TextNode.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableCellNode : ASCellNode
@property (strong, nonatomic) TextNode *titleNode;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) ASNetworkImageNode *imageNode;
@property (strong, nonatomic, nullable) id<ASLayoutElement> rightNode;
@property (strong, nonatomic, nullable) id<ASLayoutElement> leftNode;
@end

NS_ASSUME_NONNULL_END
