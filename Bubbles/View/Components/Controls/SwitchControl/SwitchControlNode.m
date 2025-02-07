//
//  SwitchControlNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "SwitchControlNode.h"
#import "PersistencyManager.h"

@implementation SwitchControlNode
- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    typeof(self) __weak weakSelf = self;
    dispatch_block_t onMain = ^{
        [(UISwitch*)[weakSelf view] setOn:isOn];
    };

    if ([NSThread isMainThread]) {
        onMain();
    } else {
        dispatch_async(dispatch_get_main_queue(), onMain);//TODO:sync does not work for some reason
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        typeof(self) __weak weakSelf = self;
        [self setViewBlock:^UIView * _Nonnull {
            UISwitch *sw = [[UISwitch alloc] init];
            [sw addTarget:weakSelf action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
            return sw;
        }];

        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)switchToggled:(UISwitch *)sender {
    BOOL isOn = [sender isOn];
    [self onChange](isOn);
}
@end
