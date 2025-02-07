//
//  MediaPickerController_Protected.h
//  Bubbles
//
//  Created by Javad on 06.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

@import UIKit;

@class MediaPickerController;
#import "Bubbles-Swift.h"

@interface MediaPickerController ()
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIViewController *picker;
@property (strong, nonatomic) PhotoViewerContainer *photoViewerContainer;
- (void)mediaPickerControllerDidCancel;
//- (void)mediaPickerControllerDidFinishPickingItems:(NSArray *)items andText:(NSString *)text;
- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text;
- (void)pickerDidFinishPicking:(NSArray *)items;
@end

