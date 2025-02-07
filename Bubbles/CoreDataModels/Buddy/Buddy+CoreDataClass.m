//
//  Buddy+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 6/27/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "Buddy+CoreDataClass.h"
#import "UserAttribute+CoreDataClass.h"
#import "Constants.h"
#import "ProfileController.h"

@implementation Buddy {
    BOOL _isFetchingVCard;
}

+ (instancetype)buddyWithUsername:(NSString *)username usingContext:(nonnull NSManagedObjectContext *)context {
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
    [request setFetchLimit:1];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    return [results firstObject];
}

- (void)fetchVCard {
    [[ProfileController sharedInstance] getProfileForUsername:[self username]];
}

- (NSString *)surname {
    NSSet<UserAttribute*> *attrs = [self attributes];
    
    NSString *surname = nil;
    for (UserAttribute *attr in attrs) {
        if ([[attr name] isEqualToString:USER_SURNAME_KEY] && [attr isVisible]) {
            surname = attr.value;
        }
    }
    
    return surname;
}

- (NSString *)name {
    NSSet<UserAttribute*> *attrs = [self attributes];
    
    NSString *name = nil;
    for (UserAttribute *attr in attrs) {
        if ([[attr name] isEqualToString:USER_NAME_KEY] && [attr isVisible]) {
            name = attr.value;
        }
    }
    
    return name;
}

- (void)setUsername:(NSString *)username {
    [self willChangeValueForKey:@"username"];
    [self setPrimitiveValue:username forKey:@"username"];
    [self didChangeValueForKey:@"username"];
    
    NSString *sectionTitle = [[username substringWithRange:NSMakeRange(3, 1)] uppercaseString];
    [self setSectionTitle:sectionTitle];
}

@end
