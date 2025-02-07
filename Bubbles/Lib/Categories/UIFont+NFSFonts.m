//
//  UIFont+NFSFonts.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "UIFont+NFSFonts.h"

@implementation UIFont(NSFonts)
+ (UIFont *)textFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Regular" size:14];
}

+ (UIFont *)boldTextFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Bold" size:14];
}

+ (UIFont *)chatCellTitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Bold" size:18];
}

+ (UIFont *)chatCellSubtitleFont {
    return [UIFont textMessageFont];
}

+ (UIFont *)postCellTitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Bold" size:20];
}

+ (UIFont *)postCellSubtitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Regular" size:14];
}

+ (UIFont *)postCellContentFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Regular" size:14];
}

+ (UIFont *)rosterCellTitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Bold" size:18];
}

+ (UIFont *)rosterCellSubtitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Regular" size:14];
}

+ (UIFont *)NFSFont {
    return [UIFont fontWithName:@"icons-font" size:32];
}

+ (UIFont *)icomoonFont {
    return [UIFont fontWithName:@"icomoon" size:28];
}

+ (UIFont *)icomoon16Font {
    return [UIFont fontWithName:@"icomoon" size:16];
}

+(UIFont *)friendRequestFeedbackFont {
    return [[UIFont textFont] fontWithSize:16];
}

+ (UIFont *)addUserUsernameFont {
    return [[UIFont textFont] fontWithSize:24];
}

+ (UIFont *)licensePlateFont {
    return [UIFont boldSystemFontOfSize:26];
}

+ (UIFont *)successFont {
    return [[UIFont textFont] fontWithSize:34];
}

+ (UIFont *)postTitleFont {
    return [[UIFont boldTextFont] fontWithSize:20];
}

+ (UIFont *)postSubtitleFont {
    return [[UIFont boldTextFont] fontWithSize:14];
}

+ (UIFont *)postContentFont {
    return [[UIFont textFont] fontWithSize:18];
}

+ (UIFont *)accountAttributeTitleFont {
    return [[UIFont textFont] fontWithSize:14];
}

+ (UIFont *)accountAttributeSubtitleFont {
    return [[UIFont textFont] fontWithSize:18];
}

+ (UIFont *)messageActionsTitleFont {
    return [[UIFont textFont] fontWithSize:18];
}

+ (UIFont *)navigationTitleFont {
    return [UIFont fontWithName:@"WayfindingSansEx-Regular" size:28];
}

+ (UIFont *)navigationSmallTitleFont {
    return [[UIFont boldTextFont] fontWithSize:18];
}

+ (UIFont *)navigationSubtitleFont {
    return [[UIFont textFont] fontWithSize:14];
}

+ (UIFont *)postCommentTitleFont {
    return [[UIFont boldTextFont] fontWithSize:16];
}

+ (UIFont *)postCommentDateFont {
    return [[UIFont textFont] fontWithSize:12];
}

+ (UIFont *)postCommentTextFont {
    return [[UIFont textFont] fontWithSize:14];
}

+ (UIFont *)messageBottomItemsFont {
    return [[UIFont textFont] fontWithSize:12];
}

+ (UIFont *)tableCellTextFont {
    return [[UIFont textFont] fontWithSize:20];
}

+ (UIFont *)tableCellSmallTextFont {
     return [[UIFont textFont] fontWithSize:18];
}

+ (UIFont *)tableCellSubtitleFont {
     return [[UIFont textFont] fontWithSize:16];
}

+ (UIFont *)textMessageFont {
     return [[UIFont textFont] fontWithSize:16];
}

@end
