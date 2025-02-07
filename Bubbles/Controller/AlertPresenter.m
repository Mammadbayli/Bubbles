//
//  AlertPresenter.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/23/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "AlertPresenter.h"
#import "AlertViewController.h"
#import "AlertViewControllerAction.h"
#import "UIFont+NFSFonts.h"

@implementation AlertPresenter
+ (instancetype)sharedInstance {
    static AlertPresenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        // write your code here
    }
    return self;
}

- (AnyPromise*)presentWithTitle:(NSString*)title message:(NSString*)message {
    return [self presentWithTitle:title message:message image:nil hasCancelButton:NO];
}

- (AnyPromise*)presentWithTitle:(NSString*)title message:(NSString*)message image:(UIImage*)image hasCancelButton:(BOOL)hasCancelButton {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSString *localizedMessage = NSLocalizedString(message, nil);
    
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:localizedMessage
                                                                                          attributes:@{
        NSFontAttributeName: [UIFont textFont]
    }];

    [attributedMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [localizedMessage length])];
    
    return [self presentWithTitle:title
                attributedMessage:attributedMessage
                            image:image hasCancelButton:hasCancelButton];
}

- (AnyPromise*)presentWithTitle:(NSString*)title attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage *)image hasCancelButton:(BOOL)hasCancelButton {
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            AlertViewController *alert = [[AlertViewController alloc] init];
            [alert setTitle:title];
            [alert setAttributedMessage:attributedMessage];
            [alert setImage:image];
            
            AlertViewControllerAction *okAction = [[AlertViewControllerAction alloc] init];
            [okAction setTitle:@"yes"];
            [okAction setStyle: AlertViewControllerActionStyleDefault];
            [okAction setHandler:^{
                resolve(nil);
            }];
            
            [alert addAction:okAction];
            
            if (hasCancelButton) {
                AlertViewControllerAction *cancelAction = [[AlertViewControllerAction alloc] init];
                [cancelAction setTitle:@"cancel"];
                [cancelAction setStyle: AlertViewControllerActionStyleDestructive];
                [cancelAction setHandler:^{
                    resolve([NSError errorWithDomain:@"alert" code:-1 userInfo:nil]);
                }];
                
                [alert addAction:cancelAction];
            }
            
            [alert setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            if ([root presentedViewController]) {
                root = [root presentedViewController];
            }
            
            [root presentViewController:alert animated:YES completion:nil];
        });
    }];
    
    return promise;
}

- (AnyPromise *)presentErrorWithMessage:(NSString *)message {
    return [self presentWithTitle:@"Error" message:message];
}

@end
