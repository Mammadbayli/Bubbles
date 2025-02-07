//
//  UserPhoto+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/12/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "UserPhoto+CoreDataClass.h"
#import "CoreDataStack.h"
#import "XMPPController.h"
#import "NSString+Random.h"
#import "UIImage+LocalFile.h"
#import "UIImage+LocalFile.h"

@implementation UserPhoto
+ (AnyPromise *)myAvatarUsingContext:(NSManagedObjectContext *)context {
    return [UserPhoto avatarForUsername:[[XMPPController sharedInstance] myUsername] usingContext:context];
}

+ (AnyPromise *)avatarForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context {
    UserPhoto *userPhoto = [UserPhoto userPhotoForUsername:username usingContext:context];
 
    if (userPhoto == nil) {
        return [AnyPromise promiseWithValue:[UIImage imageNamed:@"user"]];
    }
    
    return [userPhoto image];
}

+ (instancetype)myUserPhotoUsingContext:(NSManagedObjectContext *)context {
    UserPhoto *userPhoto = (UserPhoto *)[[self photosForUsername:[[XMPPController sharedInstance] myUsername] usingContext:context] firstObject];//TODO: Fix bug here, call perform block
    
    return userPhoto;
}

+ (instancetype)userPhotoForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context {
    UserPhoto *userPhoto = (UserPhoto *)[[self photosForUsername:username usingContext:context] firstObject];//TODO: Fix bug here, call perform block
    
    return userPhoto;
}

- (AnyPromise *)image {
    return [[PersistencyManager sharedInstance] fileWithName:[self name]].then(^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        return [AnyPromise promiseWithValue:image];
    });
}

+ (NSArray *)photosForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [UserPhoto fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return [context executeFetchRequest:request error:nil];
}

+ (instancetype)newPhotoForUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context {
    UserPhoto *photo = [[UserPhoto alloc] initWithContext:context];
    [photo setUsername:username];
    
    return photo;
}

+ (void)deletePhotoForUsername:(NSString *)username withIndex:(NSUInteger)index usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [UserPhoto fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@ AND index == %d", username, index];
    [request setPredicate:predicate];
    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
//    [request setSortDescriptors:@[sortDescriptor]];
//    [request setFetchLimit:1];
    
    NSArray *userPhotos = [context executeFetchRequest:request error:nil];
    UserPhoto *userPhoto = (UserPhoto *)[userPhotos lastObject];
    if (!userPhoto) {
        return;
    }
    
    [[CoreDataStack sharedInstance] deleteObject:userPhoto
                                    usingContext:context];
}

- (instancetype)initWithContext:(NSManagedObjectContext *)moc {
    self = [super initWithContext:moc];
    
    if (self) {
        NSString *randomName = [NSString randomFilename];
        [self setName:randomName];
    }
    
    return self;
}

- (void)setUsername:(NSString *)username {
    [self willChangeValueForKey:@"username"];
    [self setPrimitiveValue:username forKey:@"username"];
    [self didChangeValueForKey:@"username"];
    
    if ([self index] == -1) {
        NSFetchRequest *request = [UserPhoto fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
        
        [self setIndex:[[self managedObjectContext] countForFetchRequest:request error:nil]];
    }
}
@end
