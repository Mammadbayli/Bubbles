//
//  MediaPickerController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaPickerControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, MediaPickerControllerSource) {
    camera,
    photos
};

@interface MediaPickerController : NSObject
@property (weak, nonatomic) id<MediaPickerControllerDelegate> delegate;
@property (nonatomic) MediaPickerControllerSource source;
@property (nonatomic) BOOL shouldPreview;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL hasTextInput;
-(void)pickMediaFromSource: (MediaPickerControllerSource)source;
@end

NS_ASSUME_NONNULL_END
