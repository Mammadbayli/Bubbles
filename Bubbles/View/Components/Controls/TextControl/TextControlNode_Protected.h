//
//  TextControlNode_Protected.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/8/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "TextControlNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextControlNode () {
    @protected
    NSString *_text;
    NSMutableDictionary *attributes;
}

@end

NS_ASSUME_NONNULL_END
