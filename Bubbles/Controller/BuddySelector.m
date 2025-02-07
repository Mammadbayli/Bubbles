//
//  BuddySelector.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/20/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "BuddySelector.h"
#import "NavigationController.h"
#import "Bubbles-Swift.h"

@implementation BuddySelector {
    BOOL _isSelecting;
}
+ (instancetype)sharedInstance {
    static BuddySelector *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (AnyPromise *)selectWithMultipleOption:(BOOL)shouldSelectMultiple {
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        dispatch_block_t onMain = ^{
            
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            UIViewController *rootViewController = [keyWindow rootViewController];
            
            UIViewController *viewControllerToPresentOver = [rootViewController presentedViewController];
            if (viewControllerToPresentOver == nil || true) {
                viewControllerToPresentOver = rootViewController;
            }
            
            UIViewController *vc = [BuddyPickerViewContainer createWithAllowsMultipleSelection:shouldSelectMultiple onSelectBuddies:^(NSSet<NSString *> * _Nonnull buddies) {
                [viewControllerToPresentOver dismissViewControllerAnimated:YES completion:nil];
                resolve(buddies);
            }];
            
            NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:vc];
            
            NavigationController __weak *weakVC = navCtrl;

            [viewControllerToPresentOver presentViewController:weakVC animated:YES completion:nil];
        };
        
        if ([NSThread isMainThread]) {
            onMain();
        } else {
            dispatch_async(dispatch_get_main_queue(), onMain);
        }
    }];
    
    return promise;
}

@end
