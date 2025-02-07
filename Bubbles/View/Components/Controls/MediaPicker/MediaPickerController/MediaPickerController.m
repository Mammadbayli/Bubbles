//
//  MediaPickerController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "MediaPickerController.h"
#import "MediaPickerController_Protected.h"
#import "CameraCaptureViewController.h"
#import "ViewController.h"
#import "MediaPickerControllerDelegate.h"
#import "MediaPickerPhotoCellItem.h"
#import "NSData+Compression.h"
#import "MediaPickerController+UIImagePickerControllerDelegate.h"
#import "AlertPresenter.h"
#import "Bubbles-Swift.h"

@import AsyncDisplayKit;
@import PhotosUI;
@import PromiseKit;

@interface MediaPickerController()<MediaPickerControllerDelegate, PhotoViewerDelegate>
@property (strong, nonatomic) ASDKNavigationController *navController;
@end

@implementation MediaPickerController

- (UIViewController *)vcToPresentOver {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *vcToPresentOver = [keyWindow rootViewController];
    
    
    return [self topViewController:vcToPresentOver];
}

- (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc presentedViewController]) {
        return [self topViewController:[vc presentedViewController]];
    }
    
    return vc;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldPreview = YES;
        _allowsMultipleSelection = YES;
        _hasTextInput = YES;
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)pickMediaFromSource:(MediaPickerControllerSource)source {
    [self setSource:source];
    
    if([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self unsafePickMediaFromSource:source];
        });
    } else {
        [self unsafePickMediaFromSource:source];
    }
}

-(void)showAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self];
    
    [[self vcToPresentOver] presentViewController:picker animated:YES completion:nil];
    
}

- (void)unsafePickMediaFromSource:(MediaPickerControllerSource)source {
    if (source == camera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            CameraCaptureViewController *picker = [[CameraCaptureViewController alloc] init];
            [picker setDelegate:self];
            ASDKNavigationController *nav = [[ASDKNavigationController alloc] initWithRootViewController:picker];
            [[nav navigationBar] setTintColor:[UIColor whiteColor]];
          [self setPicker:picker];
            [nav setModalPresentationStyle:UIModalPresentationFullScreen];
            [[self vcToPresentOver] presentViewController:nav animated:YES completion:nil];
            
        } else {
            [[AlertPresenter sharedInstance] presentErrorWithMessage:@"Camera not available"];
        }
       
    } else {
        if (@available(iOS 14, *)) {
            PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
            [configuration setSelectionLimit:10];
            [configuration setFilter:[PHPickerFilter imagesFilter]];
            
            PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
            [picker setDelegate:(id<PHPickerViewControllerDelegate>)self];
            [self setPicker:picker];
            
            ASDKNavigationController *nav = [[ASDKNavigationController alloc] initWithRootViewController:picker];
            [nav setNavigationBarHidden:YES];
            [nav setModalPresentationStyle:UIModalPresentationFullScreen];
            [[nav navigationBar] setTintColor:[UIColor whiteColor]];
            [nav setModalPresentationCapturesStatusBarAppearance:YES];
            [[self vcToPresentOver] presentViewController:nav animated:YES completion:nil];
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)previewItems:(NSArray *)items {
    if(items > 0) {
        _photoViewerContainer = [[PhotoViewerContainer alloc] init];
        [_photoViewerContainer setDelegate:self];
        [_photoViewerContainer setHasTextInput:[self hasTextInput]];
        [_photoViewerContainer setItems:[items mutableCopy]];
        [_photoViewerContainer setHasPlusButton:[self allowsMultipleSelection]];
        [_photoViewerContainer create];

        [[[self picker] navigationController] pushViewController:[_photoViewerContainer viewController] animated:YES];
        [[[self picker] navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

- (void)mediaPickerControllerDidCancel {
    [[self items] removeAllObjects];
    if([[self delegate] respondsToSelector:@selector(mediaPickerControllerDidCancel)]) {
        [[self delegate] mediaPickerControllerDidCancel];
    }
    
    [[self vcToPresentOver] dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerDidFinishPicking:(NSArray *)items {
    if([self shouldPreview]) {
        [self previewItems:items];
    } else {
        [self mediaPickerControllerDidFinishPicking:items andText:nil];
    }
}

- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text {
    [[[self picker] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    if([[self delegate] respondsToSelector: @selector(mediaPickerControllerDidFinishPicking:andText:)]) {
        [[self delegate] mediaPickerControllerDidFinishPicking:media andText:text];
    }
    
    [[self items] removeAllObjects];
}

@end
