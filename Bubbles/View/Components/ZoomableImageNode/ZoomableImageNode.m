//
//  ZoomableImageNode.m
//  Bubbles
//
//  Created by Javad on 10.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "ZoomableImageNode.h"

@interface ZoomableImageNode()<UIScrollViewDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;
@end

@implementation ZoomableImageNode

- (UIImage *)image {
    return [[self imageNode] image];
}

- (void)setImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self scrollNode] view] setZoomScale:1 animated:YES];
    });

    [[self imageNode] setImage:image];
}

- (ASScrollNode *)scrollNode {
    if (!_scrollNode) {
        _scrollNode = [[ASScrollNode alloc] init];
    }
    
    return _scrollNode;
}

- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASImageNode alloc] init];
        [_imageNode setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return _imageNode;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAutomaticallyManagesSubnodes:YES];
    }
    
    return self;
}

- (void)didLoad {
    [super didLoad];
    
    [[[self scrollNode] view] setMinimumZoomScale:1];
    [[[self scrollNode] view] setMaximumZoomScale:10];
    [[[self scrollNode] view] addSubview:[self imageNode].view];
    [[[self scrollNode] view] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    [[[self scrollNode] view] setClipsToBounds:NO];
    
    [[[self scrollNode] view] setDelegate:self];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(doubleTapped:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setCancelsTouchesInView:NO];
    
    [[self view] addGestureRecognizer:doubleTapGesture];
    
    [self setDoubleTapGesture:doubleTapGesture];
}

- (void)layoutDidFinish {
    [super layoutDidFinish];
    
    [[self imageNode] setFrame:[self frame]];
}

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer {
    int minimumZoomScale = [[[self scrollNode] view] minimumZoomScale];
//    int maximumZoomScale = [[[self scrollNode] view] maximumZoomScale];
    if ([[[self scrollNode] view] zoomScale] > minimumZoomScale) {
        [[[self scrollNode] view] setZoomScale:minimumZoomScale animated:YES];
    } else {
        int scale = 3;
        CGPoint center = [recognizer locationInView:[self view]];
        CGRect zoomRect = CGRectZero;
        zoomRect.size.width  = self.frame.size.width  / scale;
        CGPoint newCenter = [[self view] convertPoint:center fromView:[self view]];
        zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
        zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
        [[[self scrollNode] view] zoomToRect:zoomRect animated:YES];
//        [[[self scrollNode] view] setZoomScale:maximumZoomScale animated:YES];
    }
}

- (void)didEnterVisibleState {
    [super didEnterVisibleState];
    
    for(UIGestureRecognizer *recognizer in [[[self closestViewController] view] gestureRecognizers]) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [recognizer requireGestureRecognizerToFail:[self doubleTapGesture]];
        }
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASWrapperLayoutSpec *wrapperLayout = [ASWrapperLayoutSpec wrapperWithLayoutElement:[self scrollNode]];
    
    return wrapperLayout;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[self imageNode] view];
}
@end
