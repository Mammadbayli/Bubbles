//
//  PhotoViewerController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 04.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "ViewController.h"

@interface PhotoViewerController : ViewController
@property (strong, nonatomic, retain) NSArray *photos;
@property (strong, nonatomic) BOOL (^hasMorePhotos)(void);
@property (strong, nonatomic) void (^willBatchFetch)(void);
@property (strong, nonatomic) NSString* (^titleForIndex)(NSUInteger index);
@property (strong, nonatomic) NSString* (^subtitleForIndex)(NSUInteger index);
@property (nonatomic) NSUInteger currentIndex;

- (void)deletePhotoAtIndex:(NSUInteger)index;
- (NSUInteger)deleteCurrentPhoto;
- (void)viewPhotos:(NSArray *)photos;
- (void)viewPhotos:(NSArray *)photos withSelectedIndex:(NSUInteger )index;

@end
