//
//  PostActionNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 10/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "TextNode.h"


NS_ASSUME_NONNULL_BEGIN
@class PostActionNode;
typedef void (^PostActionTapEvent)(PostActionNode* node);

@interface PostActionNode : TextNode
- (instancetype)initWith:(NSString *)icon AndText:(NSString *)label;
@property (strong, nonatomic) PostActionTapEvent onTap;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *label;
@property (nonatomic) CGFloat fontSize;
@end

NS_ASSUME_NONNULL_END
