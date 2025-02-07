//
//  CameraViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/19/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "CameraCaptureViewController.h"
#import "UIColor+NFSColors.h"
#import "AlertPresenter.h"
#import "UIFont+NFSFonts.h"
#import "NSData+Compression.h"
#import "ASViewController+CloseButton.h"
#import "MediaPickerPhotoCellItem.h"
#import "CameraCaptureViewControllerDelegate.h"

@import AVFoundation;

@interface CameraCaptureViewController ()<AVCapturePhotoCaptureDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) ASButtonNode *captureButton;
@property (nonatomic) ASButtonNode *cameraSwitchButton;
@property (nonatomic) ASButtonNode *flashModeButton;
@property (strong, nonatomic) AVCapturePhotoSettings *settings;
@property (nonatomic) AVCaptureFlashMode flashMode;
@property (strong, nonatomic) AVCaptureDevice *device;
@end

@implementation CameraCaptureViewController {
    CGPoint viewTranslation;
}

//@synthesize allowsMultipleSelection = _allowsMultipleSelection;
//@synthesize delegate = _delegate;

- (ASButtonNode *)captureButton {
    if (!_captureButton) {
        _captureButton = [[ASButtonNode alloc] init];
        [[_captureButton style] setPreferredSize:CGSizeMake(80, 80)];
        [_captureButton setCornerRadius:40];
        [_captureButton setBorderWidth:6];
        [_captureButton setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
        [_captureButton setBorderColor:[UIColor whiteColor].CGColor];
        [_captureButton setShadowColor:[UIColor blackColor].CGColor];
        [_captureButton addTarget:self
                           action:@selector(capturePhoto:)
                 forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _captureButton;
}

- (ASButtonNode *)cameraSwitchButton {
    if (!_cameraSwitchButton) {
        _cameraSwitchButton = [[ASButtonNode alloc] init];
        [_cameraSwitchButton setImage:[UIImage imageNamed:@"camera-switch"] forState:UIControlStateNormal];
        [[_cameraSwitchButton style] setPreferredSize:CGSizeMake(80, 80)];
//        [_cameraSwitchButton setCornerRadius:40];
//        [_cameraSwitchButton setBorderWidth:4];
//        [_cameraSwitchButton setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
//        [_cameraSwitchButton setBorderColor:[UIColor whiteColor].CGColor];
        [_cameraSwitchButton addTarget:self
                           action:@selector(switchCameraTapped)
                 forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _cameraSwitchButton;
}

- (ASButtonNode *)flashModeButton {
    if (!_flashModeButton) {
        _flashModeButton = [[ASButtonNode alloc] init];
        [_flashModeButton setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
        [[_flashModeButton style] setPreferredSize:CGSizeMake(80, 80)];
        //        [_cameraSwitchButton setCornerRadius:40];
        //        [_cameraSwitchButton setBorderWidth:4];
        //        [_cameraSwitchButton setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
        //        [_cameraSwitchButton setBorderColor:[UIColor whiteColor].CGColor];
        [_flashModeButton addTarget:self
                                action:@selector(toggleFlashMode)
                      forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _flashModeButton;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [[_videoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [_videoPreviewLayer setZPosition:-1];
        [_videoPreviewLayer setFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _videoPreviewLayer;
}

- (void)addGestureRecognizer {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [gestureRecognizer setCancelsTouchesInView:NO];
    [gestureRecognizer setDelaysTouchesBegan:YES];
    [gestureRecognizer setDelegate:self];
    
//    [[[self node] view] addGestureRecognizer:gestureRecognizer];
    
    UIPinchGestureRecognizer *ges = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handlePinchToZoomRecognizer:)];
    
    [[[self node] view] addGestureRecognizer:ges];
}

- (instancetype)init {
    self = [super initWithNode:[[ASDisplayNode alloc] init]];
    if (self) {
        viewTranslation = CGPointZero;
        _flashMode = AVCaptureFlashModeOff;
 
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        [[self node] setAutomaticallyManagesSubnodes:YES];
        [[self node] setBackgroundColor:[UIColor blackColor]];
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                               spacing:0
                                                                        justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                            alignItems:ASStackLayoutAlignItemsEnd
                                                                              children:@[[self cameraSwitchButton], [self captureButton], [self flashModeButton]]];
            
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 20, 0) child:stack];
        }];
        
        [self setupCamera];
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:[self view]];
    
    if (translation.x > translation.y) {
        NO;
    }
    
    return YES;
}

- (void)dismiss:(UIPanGestureRecognizer *)sender {
    switch ([sender state]) {
        case UIGestureRecognizerStateChanged: {
            viewTranslation = [sender translationInView:[self view]];
            
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                [[self view] setTransform:CGAffineTransformMake(1, 0, 0, 1, 0, self->viewTranslation.y)];
            } completion:nil];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if (viewTranslation.y < 100) {
                [UIView animateWithDuration:0.5
                                      delay:0
                     usingSpringWithDamping:0.7
                      initialSpringVelocity:1
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    [[self view] setTransform:CGAffineTransformIdentity];
                } completion:nil];
            } else {
                [self close];
            }
            break;
        default:
            break;
    }
}


- (void)setupCamera {
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];;
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:[self device]
                                                                        error:&error];
    if (!error) {
        [self setStillImageOutput:[[AVCapturePhotoOutput alloc] init]];
        
        if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.stillImageOutput]) {
            [self.captureSession addInput:input];
            [self.captureSession addOutput:self.stillImageOutput];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background Thread
                [self.captureSession startRunning];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    [[[self node] layer] insertSublayer:[self videoPreviewLayer] atIndex:0];
                });
            });
           
        }
    }
    else {
        [[AlertPresenter sharedInstance] presentWithTitle:@"Error" message:@"Error Unable to initialize back camera: %@"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setBackgroundColor:[UIColor clearColor]];
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor clearColor]];
    [[[self navigationController] navigationBar] setTranslucent:YES];
    
    [self addCloseButton];
    [self addGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self setupCamera];
}

- (void)capturePhoto:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    [settings setFlashMode:[self flashMode]];
    [[self stillImageOutput] capturePhotoWithSettings:settings delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    if (data) {
        [self savePhotoToLibrary:data];
        UIImage *image = [UIImage imageWithData:data];
        if([[self delegate] respondsToSelector:@selector(cameraCaptureViewControllerDidTakePhoto:photo:)]) {
            [[self delegate] cameraCaptureViewControllerDidTakePhoto:self photo:image];
        }
    }
}

- (void)savePhotoToLibrary:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
   
}

- (void)close {
    if([[self delegate] respondsToSelector:@selector(cameraCaptureViewControllerCancel:)]) {
        [[self delegate] cameraCaptureViewControllerCancel:self];
    }
}

- (void)dealloc {
    [self.captureSession stopRunning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)switchCameraTapped {
    //Change camera source
    if(_captureSession)
    {
        //Indicate that some changes will be made to the session
        [_captureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        [_captureSession removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        [self setDevice:newCamera];
        
        //Add input to session
        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [_captureSession addInput:newVideoInput];
        }
        
        //Commit all the configuration changes at once
        [_captureSession commitConfiguration];
    }
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:position];
    if (!device) {
        [[AlertPresenter sharedInstance] presentWithTitle:@"Error" message:@"Unable to access back camera!"];
        return nil;
    }
    
    if ([device position] == position) return device;
  
    return nil;
}

- (void)toggleFlashMode {
    if ([self flashMode] == AVCaptureFlashModeOn) {
        [[self flashModeButton] setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
        [self setFlashMode:AVCaptureFlashModeAuto];
    } else if ([self flashMode] == AVCaptureFlashModeOff) {
        [[self flashModeButton] setImage:[UIImage imageNamed:@"flash-on"] forState:UIControlStateNormal];
        [self setFlashMode:AVCaptureFlashModeOn];
    } else if ([self flashMode] == AVCaptureFlashModeAuto) {
        [[self flashModeButton] setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
        [self setFlashMode:AVCaptureFlashModeOff];
    }
}

- (void)handlePinchToZoomRecognizer:(UIPinchGestureRecognizer*)pinchRecognizer {
    const CGFloat pinchVelocityDividerFactor = 10.0f;
    
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        NSError *error = nil;
        if ([[self device] lockForConfiguration:&error]) {
            CGFloat desiredZoomFactor = [self device].videoZoomFactor + atan2f(pinchRecognizer.velocity, pinchVelocityDividerFactor);
            // Check if desiredZoomFactor fits required range from 1.0 to activeFormat.videoMaxZoomFactor
            [self device].videoZoomFactor = MAX(1.0, MIN(desiredZoomFactor, [self device].activeFormat.videoMaxZoomFactor));
            [[self device] unlockForConfiguration];
        } else {
            NSLog(@"error: %@", error);
        }
    }
}

@end
