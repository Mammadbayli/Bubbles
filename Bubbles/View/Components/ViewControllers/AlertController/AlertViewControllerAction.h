//
//  AlertViewControllerAction.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 2/6/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AlertViewControllerActionStyle {
    AlertViewControllerActionStyleDefault,
    AlertViewControllerActionStyleDestructive
} AlertViewControllerActionStyle;

typedef void(^AlertViewControllerActionHandler)(void);
NS_ASSUME_NONNULL_BEGIN

@interface AlertViewControllerAction : NSObject
@property (strong, nonatomic) NSString* title;
@property (nonatomic) AlertViewControllerActionStyle style;
@property (strong, nonatomic, nullable) AlertViewControllerActionHandler handler;
@end

NS_ASSUME_NONNULL_END
