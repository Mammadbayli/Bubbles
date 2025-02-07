//
//  AlertPresenter.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/23/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PromiseKit;

NS_ASSUME_NONNULL_BEGIN

@interface AlertPresenter : NSObject
- (AnyPromise*)presentWithTitle:(NSString*)title message:(NSString*)message;
- (AnyPromise*)presentErrorWithMessage:(NSString*)message;
- (AnyPromise*)presentWithTitle:(NSString*)title message:(NSString*)message image:(UIImage* _Nullable)image hasCancelButton:(BOOL)hasCancelButton;
- (AnyPromise*)presentWithTitle:(NSString*)title attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage*)image hasCancelButton:(BOOL)hasCancelButton;
+ (instancetype) sharedInstance;
@end

NS_ASSUME_NONNULL_END
