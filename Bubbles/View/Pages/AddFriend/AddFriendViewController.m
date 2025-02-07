//
//  AddFriendViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 1/20/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "AddFriendViewController.h"
#import "LicensePlateControlNode.h"
#import "ButtonNode.h"
#import "TextNode.h"
#import "UIFont+NFSFonts.h"
#import "NSNumber+Dimensions.h"
#import "TextControlNode.h"
#import "ActivityIndicatorPresenter.h"
#import "AlertPresenter.h"
#import "RosterController.h"
#import "XMPPController.h"
#import "Constants.h"
#import "UserAttribute+CoreDataClass.h"
#import "ProfileController.h"
#import "ProfilePhotoNode.h"
#import "UserPhoto+CoreDataClass.h"
#import "AccountViewController.h"
#import "CoreDataStack.h"

typedef enum FoundState {
    found,
    notFound,
    dirty,
    initial
} FoundState;

@interface AddFriendViewController ()
@property (strong, nonatomic) LicensePlateControlNode *licensePlateControlNode;
@property (strong, nonatomic) ButtonNode *findButtonNode;
@property (strong, nonatomic) ButtonNode *sendRequestButtonNode;
@property (strong, nonatomic) ButtonNode *retryButtonNode;
@property (strong, nonatomic) TextNode *errorTextNode;
@property (strong, nonatomic) TextNode *userTextNode;
@property (strong, nonatomic) ASImageNode *notFoundImageNode;
@property (strong, nonatomic) ProfilePhotoNode *profilePhotoNode;
@end

@implementation AddFriendViewController {
    FoundState _state;
}

- (ButtonNode *)retryButtonNode {
    if (!_retryButtonNode) {
        _retryButtonNode = [ButtonNode orangeButtonWithTitle:@"retry"];
        
        typeof(self) __weak weakSelf = self;
        [_retryButtonNode setOnCLick:^{
            [weakSelf setState:initial];
        }];
    }
    
    return _retryButtonNode;
}

- (ASImageNode *)notFoundImageNode {
    if (!_notFoundImageNode) {
        _notFoundImageNode = [[ASImageNode alloc] init];
        [_notFoundImageNode setImage:[UIImage imageNamed:@"whoops"]];
        [_notFoundImageNode setContentMode:UIViewContentModeScaleAspectFit];
        [_notFoundImageNode setClipsToBounds:YES];
        
        [[_notFoundImageNode style] setWidth:ASDimensionMake(160)];
        [[_notFoundImageNode style] setHeight:ASDimensionMake(100)];
    }
    
    return _notFoundImageNode;
}

- (LicensePlateControlNode *)licensePlateControlNode {
    if (!_licensePlateControlNode) {
        _licensePlateControlNode = [[LicensePlateControlNode alloc] init];
        typeof(self) __weak weakSelf = self;
        
        [_licensePlateControlNode setOnTextUpdate:^(NSString * _Nonnull text) {
            self->_state = dirty;
        }];
    }
    
    return _licensePlateControlNode;
}

- (ButtonNode *)findButtonNode {
    if (!_findButtonNode) {
        _findButtonNode = [ButtonNode greenButtonWithTitle:@"find"];
        [[_findButtonNode style] setMinWidth:ASDimensionMake(80)];
        [_findButtonNode setEnabled:NO];
        
        typeof(self) __weak weakSelf = self;
        [_findButtonNode setOnCLick:^{
            [weakSelf searchUser];
        }];
    }
    
    return _findButtonNode;
}

- (ButtonNode *)sendRequestButtonNode {
    if (!_sendRequestButtonNode) {
        _sendRequestButtonNode = [ButtonNode greenButtonWithTitle:@"friend_requests_send_request"];
        
        typeof(self) __weak weakSelf = self;
        
        [_sendRequestButtonNode setOnCLick:^{
            [weakSelf sendFriendRequet];
        }];
    }
    
    return _sendRequestButtonNode;
}

- (TextNode *)userTextNode {
    if (!_userTextNode) {
        _userTextNode = [[TextNode alloc] init];
        [_userTextNode setFont:[UIFont addUserUsernameFont]];
        [_userTextNode setText:@"Hidden Hidden"];
    }
    
    return _userTextNode;
}

- (TextNode *)errorTextNode {
    if (!_errorTextNode) {
        _errorTextNode = [[TextNode alloc] init];
        [_errorTextNode setText:@"friend_requests_nobody_found"];
    }
    
    return _errorTextNode;
}

- (ProfilePhotoNode *)profilePhotoNode {
    if (!_profilePhotoNode) {
        _profilePhotoNode = [[ProfilePhotoNode alloc] init];
        [_profilePhotoNode addTarget:self
                              action:@selector(navigateToProfileOfUser)
                    forControlEvents:ASControlNodeEventTouchUpInside];
        
    }
    
    return _profilePhotoNode;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setNavTitle:@"friend_requests_add_page_title"];
        
        _state = initial;
        
        typeof(self) __weak weakSelf = self;
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            NSArray *children = @[];
            
            switch (self->_state) {
                case found:
                {
                    [self setFoundState];
                    
                    ASStackLayoutSpec *buttonsStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                    spacing:5
                                                                                             justifyContent:ASStackLayoutJustifyContentCenter
                                                                                                 alignItems:ASStackLayoutAlignItemsCenter
                                                                                                   children:@[[weakSelf sendRequestButtonNode], [weakSelf retryButtonNode]]];
                    
                    children = @[[weakSelf profilePhotoNode], [weakSelf licensePlateControlNode], [weakSelf userTextNode], buttonsStackLayout];
                    break;
                }
                case notFound:
                    [self setNotFoundState];
                    children = @[[weakSelf notFoundImageNode], [weakSelf errorTextNode], [weakSelf retryButtonNode]];
                    break;
                case initial:
                    [self setInitialState];
                default:
                    children = @[[weakSelf licensePlateControlNode], [weakSelf findButtonNode]];
                    break;
            }
            
            double inset = constrainedSize.max.width*(1 - [NSNumber widthFactor])/2;
            ASLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                spacing: [NSNumber stackLayoutDefaultSpacing]
                                                                         justifyContent:ASStackLayoutJustifyContentCenter
                                                                             alignItems:ASStackLayoutAlignItemsCenter
                                                                               children:children];
            
            ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(inset, inset, inset, inset) child:stackLayout];
            [[insetLayout style] setMaxWidth:ASDimensionMake([NSNumber controlMaxWidth])];
            
            return insetLayout;
        }];
    }
    
    return self;
}

- (NSString *)username {
    return [[self licensePlateControlNode] licensePlateNumber];
}

- (void)setInitialState {
    [[self findButtonNode] setEnabled:NO];
    [[self licensePlateControlNode] setText:nil];
    [[self licensePlateControlNode] setUserInteractionEnabled:YES];
}

- (void)setFoundState {
    [self disableLicensePlateControl];
}

- (void)setNotFoundState {
    [self disableLicensePlateControl];
}

- (void)disableLicensePlateControl {
    [[self licensePlateControlNode] setUserInteractionEnabled:NO];
}

- (void)setState:(FoundState)state {
    _state = state;
    [[self node] setNeedsLayout];
}

- (void)foundUserWithResult:(id)result {
    [self setState:found];

    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    NSFetchRequest *request = [UserAttribute fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@ AND name IN %@", [self username], @[USER_NAME_KEY, USER_SURNAME_KEY]];
    [request setPredicate:predicate];
    NSArray *attributes = [context executeFetchRequest:request error:nil];
    
    UserAttribute *name;
    UserAttribute *surname;
    
    for (UserAttribute *a in attributes) {
        if ([[a name] isEqualToString:USER_NAME_KEY]) {
            name = a;
        } else {
            surname = a;
        }
    }

    NSString *visibleName = [name isVisible] ? [name value] : @"▒▒▒";
    NSString *visibleSurname = [surname isVisible] ? [surname value] : @"▒▒▒";

    [[self userTextNode] setText:[NSString stringWithFormat:@"%@ %@", visibleName, visibleSurname]];
    
    NSArray *profilePictures = [result valueForKey:USER_PHOTOS_KEY];
    NSString *profilePicture = [profilePictures firstObject];
    
    [[self profilePhotoNode] setPhotoId:profilePicture];
}

- (void)didNotFindUserWithError:(id)err {
    if ([[err localizedDescription] isEqualToString:@"The server returned a bad HTTP response code"]) {
        [self setState:notFound];
    } else {
        [[AlertPresenter sharedInstance] presentErrorWithMessage:[err localizedDescription]];
    }
}

- (void)searchUser {
    [[ActivityIndicatorPresenter sharedInstance] present];
    
    [[ProfileController sharedInstance] getProfileForUsername:[self username]]
        .then(^(id result) {
            [self foundUserWithResult:result];
        }).catch(^(id err) {
            [self didNotFindUserWithError:err];
        }).ensure(^{
            [[ActivityIndicatorPresenter sharedInstance] dismiss];
        });
}

- (void)sendFriendRequet {
    if(_state == found) {
        [[RosterController sharedInstance] sendFriendRequestToUser:[[self licensePlateControlNode] text]].then(^{
            [self setState:initial];
            [[RosterController sharedInstance] fetchRoster];
        });;
    }
}

- (void)navigateToProfileOfUser {
    //    Buddy *buddy = [[self rosterFetchedResultsController] objectAtIndexPath:indexPath];
    
    AccountViewController *accountVC = [[AccountViewController alloc] initWithUser:[self username]];
    [[self navigationController] pushViewController:accountVC animated:YES];
    //    [[self splitViewController] showDetailViewController:[[ASDKNavigationController alloc] initWithRootViewController:accountVC] sender:nil];
}

@end
