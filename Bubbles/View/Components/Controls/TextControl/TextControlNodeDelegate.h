//
//  TextControlDelegate.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/23/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextControlNode.h"

NS_ASSUME_NONNULL_BEGIN
@class TextControlNode;

@protocol TextControlNodeDelegate <NSObject>
@optional
- (void)onSubmitText:(NSString*)text;
- (void)textControlNodeDidUpdateText:(TextControlNode*)textControlNode;
- (void)textControlNodeDidBeginEditing:(TextControlNode *)textControlNode;
- (void)textControlNodeDidFinishEditing:(TextControlNode *)textControlNode;
@end

NS_ASSUME_NONNULL_END
