//
//  ButtonNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//


#import "UIColor+NFSColors.h"
#import "UIFont+NFSFonts.h"
@import AsyncDisplayKit;

typedef void (^Event)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ButtonNode : ASButtonNode
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic, nullable) NSString *text;
@property (strong, nonatomic, nullable) UIImage *image;
@property (strong, nonatomic) Event onCLick;
@property (nonatomic)  BOOL hasShadow;
+(instancetype) greenButtonWithTitle:(NSString *) title;
+(instancetype) orangeButtonWithTitle:(NSString *) title;
+(instancetype) buttonWithGreenTitle:(NSString *) title;
+(instancetype) buttonWithTitle:(NSString *) title;
+(instancetype) buttonWithIcon:(NSString *) icon;
+(instancetype) facebookButton;
@end

NS_ASSUME_NONNULL_END
