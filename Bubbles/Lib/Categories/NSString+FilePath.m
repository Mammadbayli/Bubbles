//
//  NSString+FilePath.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSString+FilePath.h"
#import "Constants.h"

@implementation NSString (FilePath)
- (instancetype)remoteFilePathForPhoto {
    NSString *remoteDirName = @"documents";
    NSString *remoteFilePath = [remoteDirName stringByAppendingPathComponent:self];
    
    return remoteFilePath;
}

- (instancetype)localFilePath {
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pathForFile = [docDirPath stringByAppendingPathComponent:self];

    return pathForFile;
}

- (instancetype)remoteFilePath {
    NSString *remoteDirName = @"documents";
    NSString *remoteFilePath = [remoteDirName stringByAppendingPathComponent:self];
    
    return remoteFilePath;
}
@end
