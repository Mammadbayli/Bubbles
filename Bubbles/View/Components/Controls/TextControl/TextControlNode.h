//
//  TextControlNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

@import AsyncDisplayKit;
#import "TextControlNodeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextControlNode : ASEditableTextNode
@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic, nullable) NSString *text;
@property (strong, nonatomic, nullable) UIFont *font;
@property (strong, nonatomic, nullable) UIColor *color;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) BOOL shouldClearOnSubmit;
@property (nonatomic) NSTextAlignment textAlignment;
@property (weak) id<TextControlNodeDelegate> textControlNodeDelegate;
@property (strong, nonatomic) void (^onTextUpdate)(NSString *);
- (void)alertValidationError;
- (void)clearValidationError;
@end

NS_ASSUME_NONNULL_END
