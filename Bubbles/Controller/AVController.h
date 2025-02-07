//
//  AVController.h
//  Bubbles
//
//  Created by Javad on 21.01.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVControllerRecordingDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVController : NSObject
+ (instancetype)sharedInstance;
- (void)playAudioData:(NSData *)data withIdentifier:(NSString *)identifier;
- (void)pausePlayback;
- (void)resumePlayback;
- (void)togglePlayback;
- (BOOL)isPlayingAudioWithIdentifier:(NSString *)identifier;
- (NSTimeInterval)durationForAudioWithData:(NSData *)data;

- (void)startRecording;
- (void)cancelRecording;
- (void)finishRecording;

@property (weak, nonatomic) id<AVControllerRecordingDelegate> recordingDelegate;
@property (strong, nonatomic, nullable) NSString* currentIdentifier;
@end

NS_ASSUME_NONNULL_END
