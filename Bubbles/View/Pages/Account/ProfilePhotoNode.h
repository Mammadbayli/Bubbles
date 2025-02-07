//
//  ProfilePhotoNode.h
//  Bubbles
//
//  Created by Javad on 19.09.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePhotoNode : ASImageNode
@property (strong, nonatomic) NSString *photoId;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end

NS_ASSUME_NONNULL_END
