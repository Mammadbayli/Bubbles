//
//  AVControllerRecordingDelegate.h
//  Bubbles
//
//  Created by Javad on 05.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVControllerRecordingDelegate <NSObject>

- (void)recordingDidFinishWithData:(NSData *)data;
- (void)recordingDidCancel;
- (void)recordingDidStart;
- (void)recordingElapsedDurationDidChange:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
