//
//  ProfilePhotoNode.m
//  Bubbles
//
//  Created by Javad on 19.09.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "ProfilePhotoNode.h"
#import "PersistencyManager.h"

@interface ProfilePhotoNode ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation ProfilePhotoNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [super init];
        [self setImage:[UIImage imageNamed:@"user"]];
        [self setCornerRadius:70];
        [[self style] setPreferredSize:CGSizeMake(140, 140)];
    }
    return self;
}

- (void)showActivityIndicator {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        [_activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_activityIndicatorView setColor:[UIColor whiteColor]];
        [_activityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        
        [[self view] addSubview:[self activityIndicatorView]];
        
        [NSLayoutConstraint activateConstraints:@[
            [[_activityIndicatorView centerYAnchor] constraintEqualToAnchor:[[self view] centerYAnchor]],
            [[_activityIndicatorView centerXAnchor] constraintEqualToAnchor:[[self view] centerXAnchor]],
            [[_activityIndicatorView heightAnchor] constraintEqualToAnchor:[[self view] heightAnchor]],
            [[_activityIndicatorView widthAnchor] constraintEqualToAnchor:[[self view] widthAnchor]]
        ]];
        
        [_activityIndicatorView startAnimating];
    }
}

- (void)hideActivityIndicator {
    if(_activityIndicatorView) {
        [_activityIndicatorView stopAnimating];

        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView = nil;
    }
}

- (void)setImage:(UIImage *)image {
    if ([_activityIndicatorView isAnimating]) {
        return;
    }
    
    [super setImage:image];
}

- (void)setPhotoId:(NSString *)photoId {
    if ([_activityIndicatorView isAnimating]) {
        return;
    }
    
    _photoId = photoId;
    
    if (!photoId) {
        [self setImage:[UIImage imageNamed:@"user"]];
        return;
    }
    
    if ([self photoId]) {
        [[PersistencyManager sharedInstance] fileWithName:photoId].then(^(id data){
            UIImage *photo = [UIImage imageWithData:data];
            
            if (photo) {
                [self setImage:photo];
            } else {
                [self setImage:[UIImage imageNamed:@"user"]];
            }
            
        });
    }
}
@end
