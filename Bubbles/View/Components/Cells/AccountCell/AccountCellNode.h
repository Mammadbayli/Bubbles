//
//  AccountCellNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/6/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "UserAttribute+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountCellNode : ASCellNode

@property (nonatomic) int shouldRound;
- (instancetype)initWithAttribute:(UserAttribute *)attribute andTitle:(NSString *)title andIsEditable:(BOOL)isEditable;
@property (strong, nonatomic) void (^onUpdate)(NSString*, BOOL);

@end

NS_ASSUME_NONNULL_END
