//
//  SettingsItem.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/25/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface SettingsItem : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
- (instancetype)initWithTitle:(NSString*)title image:(UIImage*) image;
@end
