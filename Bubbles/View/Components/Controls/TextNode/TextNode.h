//
//  TextNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/6/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextNode : ASTextNode
@property (strong, nonatomic, nullable) NSString *text;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic) NSTextAlignment textAlignment;
+(instancetype) textWithIcon: (NSString*) icon;
@end

NS_ASSUME_NONNULL_END
