//
//  NSNumber+Dimensions.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "NSNumber+Dimensions.h"
@import UIKit;

@implementation NSNumber (Dimensions)
+ (double)contentWidth {
    return 180;
}

+ (double)stackLayoutDefaultSpacing {
    return 15;
}

+ (double)controlHeight {
    return 40;
}

+ (double)postCommentImageHeight {
    return [NSNumber controlHeight];
}

+ (double)controlMaxWidth {
    return 300;
}

+ (double)logoTopDistanceFactor {
    return 0.3;
}

+ (double)widthFactor {
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        return 0.35;
//    }
    
    return 0.7;
}

+ (double)bottomPadding {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 0.4;
    }
    
    return 0.25;
}

+ (double)tableCellLateralPadding {
    return 10;
}

+ (double)tableCellVerticalPadding {
    return 5;
}

+ (double)rightViewControllerCornerRadius {
    return 20;
}

+ (double)bubbleCornerRadius {
    return 20;
}

+ (double)activityIndicatorSize {
    return 40;
}

+ (double)tableCellMinHeight {
    return 60;
}
@end
