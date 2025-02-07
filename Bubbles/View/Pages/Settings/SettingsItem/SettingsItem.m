//
//  SettingsItem.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

// UIKit;
#import "SettingsItem.h"

@implementation SettingsItem
- (instancetype)initWithTitle:(NSString*)title image:(UIImage*) image
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
    }
    return self;
}
@end
