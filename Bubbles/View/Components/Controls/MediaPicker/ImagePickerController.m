//
//  ImagePickerController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/17/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "ImagePickerController.h"
#import "PhotosGalleryViewController.h"
#import "CameraCaptureViewController.h"
#import "MediaPickerViewController.h"

@interface ImagePickerController ()
@property (strong, nonatomic, readonly) MediaPickerViewController *vc;
@end

@implementation ImagePickerController

- (void)setMediaPickerDelegate:(id<MediaPickerDelegate>)mediaPickerDelegate {
    [_vc setDelegate:mediaPickerDelegate];
}

- (instancetype)initWithSource: (ImagePickerSource)source
{
    switch (source) {
        case photos:
            _vc = [[PhotosGalleryViewController alloc] init];
            break;
            
        case camera:
            _vc = [[CameraCaptureViewController alloc] init];
            break;
    }
    
    self = [super initWithRootViewController: _vc];
    
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationFullScreen];
    }
    
    return self;
}

@end
