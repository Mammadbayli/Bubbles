//
//  CameraCaptureViewControllerDelegate.h
//  Bubbles
//
//  Created by Javad on 14.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class CameraCaptureViewController;
@protocol CameraCaptureViewControllerDelegate <NSObject>
- (void)cameraCaptureViewControllerDidTakePhoto:(CameraCaptureViewController *)viewController photo:(UIImage *)photo;
- (void)cameraCaptureViewControllerCancel:(CameraCaptureViewController *)viewController;
@end


