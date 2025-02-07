//
//  TextField.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "TextField.h"

@implementation TextField
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
}
@end
