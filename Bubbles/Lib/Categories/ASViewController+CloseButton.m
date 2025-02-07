//
//  ASDKViewController+CloseButton.m
//  Bubbles
//
//  Created by Javad on 17.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "ASViewController+CloseButton.h"
#import "UIColor+NFSColors.h"

@implementation ASDKViewController (CloseButton)
- (void)addCloseButton {
    //    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"✕" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                            target:self
                                                                            action:@selector(close)];
    [[self navigationItem] setRightBarButtonItem:button];
}
@end
