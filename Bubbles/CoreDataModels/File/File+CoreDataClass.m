//
//  File+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11.01.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//
//

#import "File+CoreDataClass.h"
#import "NSString+Random.h"
#import "NSString+FilePath.h"

@implementation File
- (instancetype)initWithContext:(NSManagedObjectContext *)moc {
    self = [super initWithContext:moc];
    
    if (self) {
        NSString *randomName = [NSString randomFilename];
        [self setName:randomName];
    }
    
    return self;
}

- (File *)copyWithContext:(NSManagedObjectContext *)context {
    File *file = [[File alloc] initWithContext:context];
    [file setName:[self name]];
    [file setType:[self type]];
    
    return file;
}

- (void)setData:(NSData *)data {
    [data writeToFile:[[self name] localFilePath] options:NSDataWritingAtomic error:nil];
}

- (AnyPromise *)upload {
    NSData *data = [NSData dataWithContentsOfFile:[[self name] localFilePath]];
    return [[PersistencyManager sharedInstance] uploadFile:data withName:[self name]];
}

- (AnyPromise *)download {
    return [[PersistencyManager sharedInstance] fileWithName:[self name]];
}
@end
