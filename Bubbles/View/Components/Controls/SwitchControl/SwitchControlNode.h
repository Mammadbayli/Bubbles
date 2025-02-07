//
//  SwitchControlNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchControlNode : ASControlNode
@property (nonatomic) BOOL isOn;
@property (strong, nonatomic) void (^onChange)(BOOL);
@end

NS_ASSUME_NONNULL_END
