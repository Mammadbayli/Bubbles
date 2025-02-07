//
//  AVController.m
//  Bubbles
//
//  Created by Javad on 21.01.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "AVController.h"
#import "NSURL+LocalFileURL.h"
#import "NSString+Random.h"
#import "Constants.h"
@import AVFoundation;
@import UIKit;

const float MIN_RECORDING_DURATION = 1;
const float PLAYBACK_UPDATE_INTERVAL = 0.05;

@interface AVController()<AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) NSTimeInterval recordingDuration;
@property (nonatomic) BOOL hasCanceled;;
@property (strong, nonatomic) NSTimer *playbackTimer;
@property (strong, nonatomic) NSTimer *recordingTimer;
@property (strong, nonatomic) AVAudioSession *session;
@end

@implementation AVController
+ (instancetype)sharedInstance {
    static AVController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AVController alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        _recordingDuration = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proximityStateDidChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (BOOL)isPlayingAudioWithIdentifier:(NSString *)identifier {
    if([[self currentIdentifier] isEqualToString:identifier]) {
        if([self player]) {
            return  [[self player] isPlaying];
        }
    }

    return NO;
}

- (void)togglePlayback {
    if([self player]) {
        if([[self player] isPlaying]) {
            [self pausePlayback];
        } else {
            [self resumePlayback];
        }
    }
}

- (NSTimeInterval)durationForAudioWithData:(NSData *)data {
    AVAudioPlayer *player = [self createPlayerWithData:data];
    return [player duration];
}

- (AVAudioPlayer *)createPlayerWithData:(NSData *)data {
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    [[self player] setVolume:1.0];
    
    return player;
}

- (void)initializePlaybackTimer {
     _playbackTimer = [NSTimer scheduledTimerWithTimeInterval:PLAYBACK_UPDATE_INTERVAL
                                                     target:self
                                                   selector:@selector(updateProgress)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_playbackTimer forMode:NSRunLoopCommonModes];
}

- (void)destroyPlaybackTimer {
    [_playbackTimer invalidate];
    _playbackTimer = nil;
}

- (void)playAudioData:(NSData *)data withIdentifier:(nonnull NSString *)identifier {
    if([[self currentIdentifier] isEqualToString:identifier]) {
        [self resumePlayback];
    } else {
        if([self player]) {
            [[self player] stop];
        }
        
        AVAudioPlayer *player = [self createPlayerWithData:data];
       
        if([player duration] == 0) {
            [self setCurrentIdentifier:nil];
            [self setPlayer:nil];
            return;
        }
        
        [self setPlayer:player];
        [self setupAVAudioSession];
        [player setDelegate:self];
        [self initializePlaybackTimer];
        
        [player play];
    }
    
    if ([self currentIdentifier]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_STOP
                                                            object:self
                                                          userInfo:@{@"identifier": [self currentIdentifier]}];
    }
    
    [self setCurrentIdentifier:identifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_START
                                                        object:self
                                                      userInfo:@{@"identifier": [self currentIdentifier]}];
}

- (void)pausePlayback {
    if([self player]) {
        [[self player] pause];
        [self destroyPlaybackTimer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_PAUSE
                                                            object:self
                                                          userInfo:@{@"identifier": [self currentIdentifier]}];
    }
}

- (void)resumePlayback {
    if([self player]) {
        [[self player] play];
        
        [self initializePlaybackTimer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_RESUME
                                                            object:self
                                                          userInfo:@{@"identifier": [self currentIdentifier]}];
    }
}

- (void)updateProgress {
    float progress = [[self player] currentTime] / [[self player] duration];
    
    NSTimeInterval duration = [[self player] duration];
    NSTimeInterval currentTime = [[self player] currentTime];
    NSTimeInterval remainingDuration = duration - currentTime;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_CURRENT_TIME_DID_CHANGE
                                                        object:self
                                                      userInfo:@{
        @"identifier": [self currentIdentifier],
        @"currentTime": [NSNumber numberWithDouble:currentTime]
    }];
}

- (void)setupAVAudioSession {
    [self enableProximityMonitoring];
    typeof(self) __weak weakSelf = self;
    
    if (![self session]) {
        [self setSession:[AVAudioSession sharedInstance]];
        [[self session] setCategory:AVAudioSessionCategoryPlayAndRecord
                         mode:AVAudioSessionModeDefault
                      options:AVAudioSessionCategoryOptionAllowAirPlay|AVAudioSessionCategoryOptionMixWithOthers
                        error:nil];
        [[self session] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                    error:nil];
        
        [[self session] setAllowHapticsAndSystemSoundsDuringRecording:YES error:nil];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [[weakSelf session] setActive:YES error:nil];
        });
    }
}

- (void)destroyAVAudioSession {
    typeof(self) __weak weakSelf = self;
    if ([self session]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [[weakSelf session] setActive:NO error:nil];
            [weakSelf setSession:nil];
            [weakSelf setSession:nil];
        });
    }
    
    [self disableProximityMonitoring];
}

- (void)enableProximityMonitoring {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

- (void)disableProximityMonitoring {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self destroyAVAudioSession];
    [self destroyPlaybackTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_STOP
                                                        object:self
                                                      userInfo:@{@"identifier": [self currentIdentifier]}];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self destroyAVAudioSession];
    
    [self destroyPlaybackTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AVCONTROLLER_PLAYBACK_DID_FINISH
                                                        object:self
                                                      userInfo:@{@"identifier": [self currentIdentifier]}];
}

- (void)proximityStateDidChange:(NSNotification *)notification {
    UIDevice *device = (UIDevice *)[notification object];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    if ([device proximityState]) {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    } else {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [self pausePlayback];
    }
}

- (void)initializeRecordingTimer {
    _recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(updateRecordingProgress)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_recordingTimer forMode:NSRunLoopCommonModes];
}

- (void)destroyRecordingTimer {
    [_recordingTimer invalidate];
    _recordingTimer = nil;
}

- (void)startRecording {
    [self initializeRecordingTimer];
    
    [self pausePlayback];
    [self setupAVAudioSession];
    
    NSURL *outputFileURL = [NSURL urlForFile:[NSString randomFilename]];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue: [NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue: [NSNumber numberWithFloat: 24000.0] forKey:AVSampleRateKey];
    [recordSetting setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    
    [[self recorder] prepareToRecord];
    [[self recorder] record];
    
    _recordingDuration = 0;
    
    if([[self recordingDelegate] respondsToSelector:@selector(recordingDidStart)]) {
        [[self recordingDelegate] recordingDidStart];
    }
}

- (void)updateRecordingProgress {
    _recordingDuration += 1;
    
    if ([[self recordingDelegate] respondsToSelector:@selector(recordingElapsedDurationDidChange:)]) {
        [[self recordingDelegate] recordingElapsedDurationDidChange:_recordingDuration];
    }
}

- (void)cancelRecording {
    _hasCanceled = YES;
    
    [self destroyRecordingTimer];
    
    [[self recorder]stop];
    [[self recorder] deleteRecording];
    [self destroyAVAudioSession];
    
    if([[self recordingDelegate] respondsToSelector:@selector(recordingDidCancel)]) {
        [[self recordingDelegate] recordingDidCancel];
    }
    
    if ([[self recordingDelegate] respondsToSelector:@selector(recordingElapsedDurationDidChange:)]) {
        [[self recordingDelegate] recordingElapsedDurationDidChange:0];
    }
}

- (void)finishRecording {
    [[self recorder] stop];
    [self destroyAVAudioSession];
    
    [self destroyRecordingTimer];
    
    if ([[self recordingDelegate] respondsToSelector:@selector(recordingElapsedDurationDidChange:)]) {
        [[self recordingDelegate] recordingElapsedDurationDidChange:0];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if(flag && ![self hasCanceled]) {
        if ([self recordingDuration] >= MIN_RECORDING_DURATION) {
            if([[self recordingDelegate] respondsToSelector:@selector(recordingDidFinishWithData:)]) {
                NSData *data = [NSData dataWithContentsOfURL:[recorder url]];
                
                [[self recordingDelegate] recordingDidFinishWithData:data];
            }
        }
    }
    
    if ([self hasCanceled]) {
        [self setHasCanceled:NO];
    }
    
    [self destroyRecordingTimer];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [self destroyRecordingTimer];
}

@end
