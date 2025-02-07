//
//  OneTimeCodeTextControlNode.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AsyncDisplayKit;

NS_ASSUME_NONNULL_BEGIN

@interface OneTimeCodeTextControlNode : ASDisplayNode
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) void (^onTextUpdate)(NSString *);
@end

NS_ASSUME_NONNULL_END
