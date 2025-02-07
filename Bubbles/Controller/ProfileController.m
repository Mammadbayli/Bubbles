//
//  ProfileController.m
//  Bubbles
//
//  Created by Javad on 25.07.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "ProfileController.h"
#import "APIRequest.h"
#import "NSURLSession+CertificatePinning.h"
#import "CoreDataStack.h"
#import "UserAttribute+CoreDataClass.h"
#import "UserPhoto+CoreDataClass.h"
#import "Buddy+CoreDataClass.h"
#import "Constants.h"
#import "XMPPController.h"
#import "LoggerController.h"

@implementation ProfileController
+ (instancetype)sharedInstance {
    static ProfileController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (AnyPromise *)getProfileForUsername:(NSString *)username {
    NSMutableURLRequest *request = [APIRequest GETRequestWithPath:[NSString stringWithFormat:@"profile/%@", username]];
    
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request]
    .then(^(id reply){
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
            NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
            NSManagedObjectContext *mainContext = [[CoreDataStack sharedInstance] mainContext];
            
            [context performBlock:^{
                NSFetchRequest *request = [UserAttribute fetchRequest];
                
                NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"NOT (name IN %@) AND username == %@", [reply allKeys], username];//delete thos that are not in remote answer
                [request setPredicate:deletePredicate];
                
                NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
                [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
                
                NSBatchDeleteResult *batchDeleteResult = [context executeRequest:batchDeleteRequest error:nil];
                NSArray *deletedObjectIDs = [batchDeleteResult result];
                [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: deletedObjectIDs}
                                                             intoContexts:@[mainContext, context]];
                
                NSFetchRequest *attributesRequest = [UserAttribute fetchRequest];
                
                NSPredicate *attributesPredicate = [NSPredicate predicateWithFormat:@"username == %@", username];
                [attributesRequest setPredicate:attributesPredicate];
                
                NSArray *attrsArray = [context executeFetchRequest:attributesRequest error:nil];
                
                NSMutableDictionary<NSString*, UserAttribute*> *attrsDict = [[NSMutableDictionary alloc] init];
                
                Buddy *buddy = [Buddy buddyWithUsername:username usingContext:context];
                
                for (UserAttribute *a in attrsArray) {
                    attrsDict[a.name] = a;
                }
                
                for (NSString *key in [reply allKeys]) {
                    if (!key || ![key length]) {
                        continue;
                    }
                    
                    UserAttribute *attr = attrsDict[key];
                    
                    if (!attr) {
                        attr = [[UserAttribute alloc] initWithContext:context];
                        [attr setUsername:username];
                        [attr setName:key];
                    }
                    
                    NSDictionary *json = reply[key];
                    [attr parseValues:json];
                    
                    [buddy addAttributesObject:attr];
                }
                
                NSArray *photoNames = [reply objectForKey:@"profile-pictures"];
                [self processPictures:photoNames forUsername:username withContext:context];
                
                [[CoreDataStack sharedInstance] saveContext:context].then(^{
                    resolve(reply);
                });
            }];
        }];
    });
}

- (AnyPromise *)processPictures:(NSArray *)pictures forUsername:(NSString *)username withContext:(NSManagedObjectContext *)context {
    NSArray *photoNames = pictures;
    if (!photoNames || ![photoNames respondsToSelector:@selector(count)]) {
        photoNames = @[];
    }
    
    NSManagedObjectContext *mainContext = [[CoreDataStack sharedInstance] mainContext];
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [context performBlock:^{
            NSFetchRequest *request = [UserPhoto fetchRequest];
            
            NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"NOT (name IN %@) AND username == %@", photoNames, username];//delete thos that are not in remote answer
            [request setPredicate:deletePredicate];
            
            NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
            [batchDeleteRequest setResultType:NSBatchDeleteResultTypeObjectIDs];
            
            NSError *error;
            NSBatchDeleteResult *batchDeleteResult = [context executeRequest:batchDeleteRequest error:&error];
            
            NSArray *deletedObjectIDs = [batchDeleteResult result];
            
            [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: deletedObjectIDs}
                                                         intoContexts:@[mainContext]];
            
            Buddy *buddy = [Buddy buddyWithUsername:username usingContext:context];
            NSOrderedSet *currentPhotos = [buddy photos];
            
            for (int i = 0; i < [pictures count]; i++) {
                NSString *photoName = [pictures objectAtIndex:i];
                if (!(photoName && [photoName length])) { return; }
                
                BOOL didFind = NO;
                
                for (int j = 0; j < [currentPhotos count]; j++) {
                    UserPhoto *currentPhoto = (UserPhoto *)[currentPhotos objectAtIndex:j];
                    
                    if ([[currentPhoto name] isEqualToString:photoName]) {
                        if (i != [currentPhoto index]) {
                            [currentPhoto setIndex:i];
                            [buddy removePhotosObject:currentPhoto];
                            [buddy addPhotosObject:currentPhoto];
                        }
                        
                        didFind = YES;
                        break;
                    }
                }
                
                if (!didFind) {
                    UserPhoto *photo = [[UserPhoto alloc] initWithContext:context];
                    [photo setUsername:username];
                    [photo setName:photoName];
                    [photo setIndex:i];
                    
                    [buddy addPhotosObject:photo];
                }
            }
            
            resolve(nil);
        }];
    }];
}

- (AnyPromise *)processPicturesAndSave:(NSArray *)pictures forUsername:(NSString *)username withContext:(NSManagedObjectContext *)context {
    return [self processPictures:pictures forUsername:username withContext:context].then(^{
        [[CoreDataStack sharedInstance] saveContext:context];
    });
}

- (AnyPromise *)updateProfilePictures:(NSArray *)pictures forUsername:(NSString *)username withContext:(NSManagedObjectContext *)context {
    return [self processPicturesAndSave:pictures forUsername:username withContext:context].then(^{
        NSDictionary *value = @{@"value": pictures};
        
        return [self setProfileValue:value
                              ForKey:USER_PHOTOS_KEY
                         ForUsername:username];
    });
}

- (AnyPromise *)setProfileValue:(NSDictionary *)value ForKey:(NSString *)key ForUsername:(NSString *)username {
    APIRequest *request = [APIRequest PATCHRequestWithPath: [NSString stringWithFormat:@"profile/%@/%@", username, key]];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    return [[NSURLSession certificatePinnedSession] promiseDataTaskWithRequest:request];
}
@end
