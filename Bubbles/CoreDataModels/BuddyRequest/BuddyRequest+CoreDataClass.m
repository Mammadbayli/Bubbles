//
//  BuddyRequest+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 3/18/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "BuddyRequest+CoreDataClass.h"

@implementation BuddyRequest
+ (instancetype)buddyRequestWithUsername:(NSString *)username usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
    [request setFetchLimit:1];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    return [results firstObject];
}
@end
