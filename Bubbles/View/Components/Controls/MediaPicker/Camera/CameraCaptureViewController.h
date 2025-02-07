//
//  CameraViewController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/19/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CameraCaptureViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraCaptureViewController : ASDKViewController
@property (weak, nonatomic) id<CameraCaptureViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
