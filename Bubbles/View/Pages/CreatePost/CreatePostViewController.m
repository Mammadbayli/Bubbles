//
//  CreatePostViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/16/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "CreatePostViewController.h"
#import "TextControlNode.h"
#import "TextNode.h"
#import "UserPhoto+CoreDataClass.h"
#import "UIFont+NFSFonts.h"
#import "XMPPController.h"
#import "Constants.h"
#import "ButtonNode.h"
#import "Post+CoreDataClass.h"
#import "CoreDataStack.h"
#import "MediaPickerController.h"
#import "MediaPickerControllerDelegate.h"
#import "PostActionNode.h"
#import "ChatRoom+CoreDataClass.h"

@interface CreatePostViewController ()<MediaPickerControllerDelegate>

@property (strong, nonatomic) TextNode *usernameTextNode;
@property (strong, nonatomic) ASImageNode *userAvatarImageNode;
@property (strong, nonatomic) TextControlNode *postTitleTextControlNode;
@property (strong, nonatomic) TextControlNode *postBodyTextControlNode;
@property (strong, nonatomic) PostActionNode *cameraCaptureTextNode;
@property (strong, nonatomic) PostActionNode *pickFromPhotosTextNode;
@property (strong, nonatomic) MediaPickerController *mediaPickerController;
@property (strong, nonatomic) UIButton *postButton;

@end

@implementation CreatePostViewController {
    NSString *_roomId;
    NSArray *_photos;
}

- (void)validatePostButton {
    BOOL newState = NO;
    
    if ([[self postTitleTextControlNode] text] && [[[self postTitleTextControlNode] text] length] && [[self postBodyTextControlNode] text] && [[[self postBodyTextControlNode] text] length]) {
        newState = YES;
    }
    
    if (newState) {
        [[self postButton] setUserInteractionEnabled:YES];
        [[self postButton] setAlpha:1];
    } else {
        [[self postButton] setUserInteractionEnabled:NO];
        [[self postButton] setAlpha:0.5];
    }
    
}

- (ASImageNode *)userAvatarImageNode {
    if(!_userAvatarImageNode) {
        _userAvatarImageNode = [[ASImageNode alloc] init];
        
        
        typeof(self) __weak weakSelf = self;
        NSManagedObjectContext *context = [[CoreDataStack sharedInstance] mainContext];
        
        [context performBlock:^{
            [UserPhoto myAvatarUsingContext:context].then(^(UIImage *avatar){
                [[weakSelf userAvatarImageNode] setImage:avatar];
            });
        }];
    
        [_userAvatarImageNode setContentMode:UIViewContentModeScaleAspectFill];
        [_userAvatarImageNode  setLayerBacked:YES];
        [[_userAvatarImageNode style] setWidth:ASDimensionMake(40)];
        [[_userAvatarImageNode style] setHeight:ASDimensionMake(40)];
        
        [_userAvatarImageNode setCornerRadius:8];
    }
    
    return _userAvatarImageNode;
}

- (TextNode *)usernameTextNode {
    if(!_usernameTextNode) {
        _usernameTextNode = [[TextNode alloc] init];
        [_usernameTextNode setFont:[UIFont postTitleFont]];
        [_usernameTextNode setText:[[[PersistencyManager sharedInstance] getUsername] uppercaseString]];
    }
    
    return _usernameTextNode;
}

- (TextControlNode *)postTitleTextControlNode {
    if(!_postTitleTextControlNode) {
        _postTitleTextControlNode = [[TextControlNode alloc] init];
        [_postTitleTextControlNode setPlaceholder:@"Subject"];
        
        typeof(self) __weak weakSelf = self;
        [_postTitleTextControlNode setOnTextUpdate:^(NSString * _Nonnull text) {
        }];
    }
    
    return _postTitleTextControlNode;
}

- (TextControlNode *)postBodyTextControlNode {
    if(!_postBodyTextControlNode) {
        _postBodyTextControlNode = [[TextControlNode alloc] init];
        [[_postBodyTextControlNode style] setMinHeight:ASDimensionMake(100)];
        [_postBodyTextControlNode setPlaceholder:@"Body"];
        
        typeof(self) __weak weakSelf = self;
        [_postBodyTextControlNode setOnTextUpdate:^(NSString * _Nonnull text) {
        }];
    }
    
    return _postBodyTextControlNode;
}

- (PostActionNode *)cameraCaptureTextNode {
    if(!_cameraCaptureTextNode) {
        _cameraCaptureTextNode = [[PostActionNode alloc] initWith:@"\ue90f" AndText:@"photo_source_camera"];
        [_cameraCaptureTextNode setFontSize:18];
    }
    
    return _cameraCaptureTextNode;
}

- (PostActionNode *)pickFromPhotosTextNode {
    if(!_pickFromPhotosTextNode) {
        _pickFromPhotosTextNode = [[PostActionNode alloc] initWith:@"\ue90d" AndText:@"photo_source_photos"];
        [_pickFromPhotosTextNode setFontSize:18];
    }
    
    return _pickFromPhotosTextNode;
}

- (instancetype)initForGroupId:(NSString *)roomId{
    self = [super init];
    if (self) {
        [self setNavTitle:@"create_post"];
        
        _roomId= roomId;
        
        _mediaPickerController = [[MediaPickerController alloc] init];
        [_mediaPickerController setDelegate:self];
        [_mediaPickerController setHasTextInput:NO];
        [_mediaPickerController setAllowsMultipleSelection:YES];
        
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        typeof(self) __weak weakSelf = self;
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASStackLayoutSpec *senderStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                           spacing:4
                                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                                          children:@[[weakSelf userAvatarImageNode], [weakSelf usernameTextNode]]];
            
            ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                     spacing:10
                                                                              justifyContent:ASStackLayoutJustifyContentStart
                                                                                  alignItems:ASStackLayoutAlignItemsStretch
                                                                                    children:@[senderStackLayout,
                                                                                               [weakSelf postTitleTextControlNode],
                                                                                               [weakSelf postBodyTextControlNode],
                                                                                               [weakSelf cameraCaptureTextNode],
                                                                                               [weakSelf pickFromPhotosTextNode]
                                                                                    ]];
            
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(40, 20, 20, 20) child:stackLayout];
        }];
    }
    return self;
}

- (void)setupCancelButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"✕" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont navigationTitleFont]];
    [button setContentMode:UIViewContentModeScaleToFill];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setLeftBarButtonItem:closeBarButtonItem];
}

- (void)setupPostButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button addTarget:self action:@selector(sendPost) forControlEvents:UIControlEventTouchUpInside];
    NSString *buttonTitle = NSLocalizedString(@"send_post", nil);
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont textFont]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [[button titleLabel] setFont:[UIFont navigationTitleFont]];
    [button setContentMode:UIViewContentModeScaleToFill];
    [[button layer] setCornerRadius:10];
    [button setClipsToBounds:YES];
    [button setBackgroundColor:[UIColor greenButtonColor]];
    [button setUserInteractionEnabled:NO];
    [button setAlpha:0.5];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:closeBarButtonItem];
    
    [self setPostButton:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCancelButton];
    [self setupPostButton];
//    ButtonNode *postButton = [ButtonNode greenButtonWithTitle:@"Post"];
//    [postButton setFrame:CGRectMake(0, 0, 100, 80)];
//
//    UIBarButtonItem *postBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[postButton view]];
//
//    [[self navigationItem] setRightBarButtonItem:postBarButtonItem];
    
    [[self cameraCaptureTextNode] addTarget:self
                                     action:@selector(openCamera)
                           forControlEvents:ASControlNodeEventTouchUpInside];
    
    [[self pickFromPhotosTextNode] addTarget:self
                                      action:@selector(pickFromPhotos)
                            forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)cancel {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendPost {
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] mainContext];
    Post *post = [[Post alloc] initWithContext:context];
    
//    [post addFiles:_photos];
    [post setFilesArray:_photos withType:MESSAGE_TYPE_PHOTO];
    
    ChatRoom *room = [ChatRoom roomWithId:_roomId usingContext:context];
    [post setRoom:room];
    [post setTitle:[[self postTitleTextControlNode] text]];
    [post setBody:[[self postBodyTextControlNode] text]];
    [post setIsUnread:NO];
    [post send];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCamera {
    [[self mediaPickerController] pickMediaFromSource:camera];
}

- (void)pickFromPhotos {
    [[self mediaPickerController] pickMediaFromSource:photos];
}

- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (UIImage *image in media) {
        [array addObject:UIImageJPEGRepresentation(image, 1)];
    }
    
    _photos = array;
}

@end
