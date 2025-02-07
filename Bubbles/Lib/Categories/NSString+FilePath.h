//
//  NSString+FilePath.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FilePath)
- (instancetype)remoteFilePathForPhoto;
- (instancetype)localFilePath;
- (instancetype)remoteFilePath;
@end

NS_ASSUME_NONNULL_END
