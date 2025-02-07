//
//  MediaPickerController+PhotoViewerDelegate.m
//  Bubbles
//
//  Created by Javad on 06.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "MediaPickerController+PhotoViewerDelegate.h"
#import "MediaPickerController_Protected.h"
#import "MediaPickerPhotoCellItem.h"

@implementation MediaPickerController (PhotoViewerDelegate)
- (void)photoViewerControllerDidAskForMorePhotos {
    [[[[self photoViewerContainer] viewController] navigationController] popViewControllerAnimated:YES];
    [[[[self photoViewerContainer] viewController] navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)photoViewerDidCancel {
    [[[self photoViewerContainer] viewController] dismissViewControllerAnimated:YES completion:nil];
    [self mediaPickerControllerDidCancel];
}

- (void)photoViewerDidConfirmWithText:(NSString *)text items:(NSArray<UIImage *> *)items {
    [self mediaPickerControllerDidFinishPicking:items andText:text];
}

- (void)photoViewerDidDeletePhotoAtIndexWithIndex:(NSInteger)index {
    [[self items] removeObjectAtIndex:index];
}

@end
