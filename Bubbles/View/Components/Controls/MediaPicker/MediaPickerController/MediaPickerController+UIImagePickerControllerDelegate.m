//
//  MediaPickerController+UIImagePickerControllerDelegate.m
//  Bubbles
//
//  Created by Javad on 06.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "MediaPickerController+UIImagePickerControllerDelegate.h"
#import "MediaPickerController_Protected.h"
#import "MediaPickerPhotoCellItem.h"

@implementation MediaPickerController (UIImagePickerControllerDelegate)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage] ? : info[UIImagePickerControllerOriginalImage];
    [[self items] addObject:image];
    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [self pickerDidFinishPicking:[self items]];
//    }];
    
    
    [self pickerDidFinishPicking:[self items]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self mediaPickerControllerDidCancel];
}
@end
