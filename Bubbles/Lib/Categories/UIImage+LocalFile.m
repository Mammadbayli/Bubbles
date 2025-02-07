//
//  UIImage+LocalFile.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 06.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "UIImage+LocalFile.h"
#import "NSString+FilePath.h"

@implementation UIImage (LocalFile)
+ (instancetype)imageWithName:(NSString *)name {
    return [UIImage imageWithContentsOfFile:[name localFilePath]];
}
@end
