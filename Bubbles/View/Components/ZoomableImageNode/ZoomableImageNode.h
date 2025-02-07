//
//  ZoomableImageNode.h
//  Bubbles
//
//  Created by Javad on 10.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZoomableImageNode : ASDisplayNode
@property (nullable) UIImage *image;

@property (strong, nonatomic) ASScrollNode *scrollNode;
@property (strong, nonatomic) ASImageNode *imageNode;

@end

NS_ASSUME_NONNULL_END
