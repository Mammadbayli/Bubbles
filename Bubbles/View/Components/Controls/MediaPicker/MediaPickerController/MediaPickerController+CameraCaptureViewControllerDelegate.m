//
//  MediaPickerController+CameraCaptureViewControllerDelegate.m
//  Bubbles
//
//  Created by Javad on 14.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "MediaPickerController+CameraCaptureViewControllerDelegate.h"
#import "MediaPickerController_Protected.h"

@implementation MediaPickerController (CameraCaptureViewControllerDelegate)
- (void)cameraCaptureViewControllerCancel:(CameraCaptureViewController *)viewController {
    [self mediaPickerControllerDidCancel];
}

- (void)cameraCaptureViewControllerDidTakePhoto:(CameraCaptureViewController *)viewController photo:(id)photo {
    [[self items] addObject:photo];
    [self pickerDidFinishPicking:[self items]];
}

@end
