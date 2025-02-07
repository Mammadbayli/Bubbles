//
//  PhotoViewerCellNode.m
//  Bubbles
//
//  Created by Javad on 10.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import "PhotoViewerCellNode.h"
#import "PersistencyManager.h"
#import "ZoomableImageNode.h"

@interface PhotoViewerCellNode()
@property (strong, nonatomic) ZoomableImageNode *imageNode;
@property (strong, nonatomic) NSString *photoName;
@end

@implementation PhotoViewerCellNode
- (ZoomableImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ZoomableImageNode alloc] init];
        [_imageNode setImage:[UIImage imageNamed:@"dark-placeholder"]];
    }
    
    return _imageNode;
}

- (instancetype)initWithPhotoName:(NSString *)photo {
    self = [super init];
    
    if (self) {
        _photoName = photo;
        [self setAutomaticallyManagesSubnodes:YES];
    }
    
    return self;
}

- (void)displayPhoto {
    [[PersistencyManager sharedInstance] fileWithName:[self photoName]]
        .then(^(NSData *data) {
            UIImage *image = [UIImage imageWithData:data];
            
            if (image) {
                [self.imageNode setImage:image];
            }
        });
}

//- (void)didEnterPreloadState {
//    [super didEnterPreloadState];
//
//    [[PersistencyManager sharedInstance] fileWithName:[self photoName]]
//        .then(^(NSData *data) {
//            UIImage *image = [UIImage imageWithData:data];
//
//            if (image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.imageNode setImage:image];
//                });
//            }
//        });
//}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASWrapperLayoutSpec *wrapperLayout = [ASWrapperLayoutSpec wrapperWithLayoutElement:[self imageNode]];
    
    return wrapperLayout;
}

@end
