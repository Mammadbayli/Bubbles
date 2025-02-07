//
//  ImagePickerController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/17/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "MediaPickerDelegate.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum ImagePickerSource {
     camera,
     photos
}ImagePickerSource;

@interface ImagePickerController : ASNavigationController
- (instancetype)initWithSource: (ImagePickerSource)source;
@property (weak, nonatomic) id<MediaPickerDelegate> mediaPickerDelegate;
@end

NS_ASSUME_NONNULL_END
