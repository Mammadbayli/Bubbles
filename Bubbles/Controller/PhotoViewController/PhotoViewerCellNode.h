//
//  PhotoViewerCellNode.h
//  Bubbles
//
//  Created by Javad on 10.02.22.
//  Copyright © 2022 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoViewerCellNode : ASCellNode

- (instancetype)initWithPhotoName:(NSString *)photo;
- (void)displayPhoto;

@end

NS_ASSUME_NONNULL_END
