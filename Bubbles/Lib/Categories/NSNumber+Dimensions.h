//
//  NSNumber+Dimensions.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/5/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Dimensions)
+(double)contentWidth;
+(double)stackLayoutDefaultSpacing;
+(double)controlHeight;
+(double)tableCellMinHeight;
+(double)logoTopDistanceFactor;
+(double)widthFactor;
+(double)controlMaxWidth;
+(double)bottomPadding;
+(double)tableCellLateralPadding;
+(double)tableCellVerticalPadding;
+ (double)rightViewControllerCornerRadius;
+ (double)bubbleCornerRadius;
+(double)postCommentImageHeight;
+ (double)activityIndicatorSize;
@end

NS_ASSUME_NONNULL_END
