//
//  ActivityIndicatorPresenter.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 12/14/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "ActivityIndicatorPresenter.h"
#import "NSNumber+Dimensions.h"
#import "UIColor+NFSColors.h"
@import UIKit;

@interface ActivityIndicatorPresenter()
@property (strong, nonatomic)  UIImageView *activityIndicatorView;
@property (nonatomic)  BOOL isPresenting;
@end

@implementation ActivityIndicatorPresenter

+ (instancetype)sharedInstance {
    static ActivityIndicatorPresenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _isPresenting = NO;
    }
    
    return self;
}

-(UIWindow*)keyWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

- (void)present {
    if (![self isPresenting]) {
        [self setIsPresenting:YES];
        
        if([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self unsafePresent];
            });
        } else {
            [self unsafePresent];
        }
    }
}

- (void)dismiss {
    if ([self isPresenting]) {
        [self setIsPresenting:NO];
        
        if([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self unsafeDismiss];
            });
        } else {
            [self unsafeDismiss];
        }
    }
}

- (void)animate {
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        [[weakSelf activityIndicatorView] setTransform:CGAffineTransformRotate([[weakSelf activityIndicatorView] transform], M_PI)];
    } completion:^(BOOL finished) {
        if ([weakSelf isPresenting]) {
            [weakSelf animate];
        }
    }];
}

- (void)stopAnimating {
    [[[self activityIndicatorView] layer] removeAllAnimations];//TODO: call on main thread
}

-(void)unsafePresent {
    CGFloat x = [[UIScreen mainScreen] bounds].size.width/2 - [NSNumber activityIndicatorSize]/2;
    CGFloat y = [[UIScreen mainScreen] bounds].size.height/2 - [NSNumber activityIndicatorSize]/2;
    
    _activityIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y,
                                                                           [NSNumber activityIndicatorSize],
                                                                           [NSNumber activityIndicatorSize])];
    
    [_activityIndicatorView setImage:[UIImage imageNamed:@"spinning-wheel"]];
    
    [self animate];
    [[self keyWindow] addSubview:[self activityIndicatorView]];
    [[self keyWindow]setUserInteractionEnabled:NO];
}

-(void)unsafeDismiss {
    [self stopAnimating];
    [[self activityIndicatorView] removeFromSuperview];
    [[self keyWindow] setUserInteractionEnabled:YES];
}

@end
