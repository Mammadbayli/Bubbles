//
//  NSURL+LocalFileURL.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/24/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//

#import "NSURL+LocalFileURL.h"
#import "NSString+FilePath.h"

@implementation NSURL (LocalFileURL)
+ (instancetype)urlForFile:(NSString *)filename {
    NSString *pathForFile = [filename localFilePath];
    NSURL *localFileURL = [NSURL fileURLWithPath:pathForFile];
    
    return localFileURL;
}
@end
