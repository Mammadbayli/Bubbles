//
//  UIColor+NFSColors.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "UIColor+NFSColors.h"

@implementation UIColor (NFSColors)
+ (UIColor *)lighterBackgroundColor {
    if (@available(iOS 13, *)) {
        return [UIColor tertiarySystemBackgroundColor];
    }
    
    return [UIColor whiteColor];

    //    return [UIColor colorWithRed:246.0/255 green:246.0/255 blue:225.0/255 alpha:1];
}

+ (UIColor *)lightBackgroundColor {
    if (@available(iOS 13, *)) {
        return [UIColor systemBackgroundColor];
    }
    
    return [UIColor colorWithRed:200/255 green:199/255 blue:203/255 alpha:1];
//    return [UIColor colorWithRed:246.0/255 green:246.0/255 blue:225.0/255 alpha:1];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:250/255 green:250/255 blue:248/255 alpha:1];

//    return [UIColor colorWithRed:253.0/255 green:255.0/255 blue:231.0/255 alpha:1];
}

+ (UIColor *)greenButtonColor {
    return [UIColor colorWithRed:160.0/255 green:214.0/255 blue:189.0/255 alpha:1];
}

+ (UIColor *)NFSOrangeColor {
    return [UIColor colorWithRed:235.0/255 green:180.0/255 blue:65.0/255 alpha:1];
}

+ (UIColor *)placeholderColor {
    return [UIColor colorWithRed:234.0/255 green:233.0/255 blue:222.0/255 alpha:1];
}

+ (UIColor *)textColor {
    return [UIColor blackColor];
    return [UIColor colorWithRed:178.0/255 green:178.0/255 blue:171.0/255 alpha:1];
}

+ (UIColor *)darkTextColor {
    return [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
}

+ (UIColor *)lightTextColor {
    return [UIColor systemGrayColor];
    return [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
}

+ (UIColor *)textControlBorderColor {
    if (@available(iOS 15, *)) {
        return [UIColor separatorColor];
    }
    
    return [UIColor colorWithRed:225.0/255 green:223.0/255 blue:227.0/255 alpha:1];
}

+ (UIColor *)lighterTextColor {
    if (@available(iOS 13, *)) {
        return [UIColor systemGray2Color];
    }

    return [UIColor lightGrayColor];
}

+ (UIColor *)NFSGreenColor {
    return [UIColor colorWithRed:125.0/255 green:190.0/255 blue:130.0/255 alpha:1];
}

+ (UIColor *)NFSGrayColor {
    return [UIColor colorWithRed:231.0/255 green:231.0/255 blue:218.0/255 alpha:1];
}

+ (UIColor *)facebookBlueColor {
    return [UIColor colorWithRed:124.0/255 green:157.0/255 blue:206.0/255 alpha:1];
}

+ (UIColor *)tableHeaderColor {
    return [UIColor colorWithRed:249.0/255 green:249.0/255 blue:236.0/255 alpha:1];
}

+ (UIColor *)tableHeaderTextColor {
    return [UIColor colorWithRed:187.0/255 green:187.0/255 blue:180.0/255 alpha:1];
}

+ (UIColor *)selfMessageBubbleColor {
    return [UIColor colorWithRed:243.0/255 green:254.0/255 blue:249.0/255 alpha:1];
}

+ (UIColor *)otherMessageBubbleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)messageBubbleShadowColor {
    return [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.05];
}

@end
