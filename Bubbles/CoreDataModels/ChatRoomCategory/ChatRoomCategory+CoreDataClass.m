//
//  ChatRoomCategory+CoreDataClass.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 7/1/20.
//  Copyright © 2020 Javad Mammadbayli. All rights reserved.
//
//

#import "ChatRoomCategory+CoreDataClass.h"
#import "ChatRoom+CoreDataClass.h"
#import "CoreDataStack.h"
//rooms =     (
//            {
//        icon = "http://api.mammadbayli.com/img/bmw.png";
//        jid = "bmw@conference.im.mammadbayli.com";
//        name = BMW;
//    },
//            {
//        icon = "http://api.mammadbayli.com/img/merc.png";
//        jid = "mercedes@conference.im.mammadbayli.com";
//        name = Mercedes;
//    }
//);
@implementation ChatRoomCategory
+ (instancetype)categoryWithObject:(NSDictionary*)object usingContext:(NSManagedObjectContext*)context {
    ChatRoomCategory *category = [[ChatRoomCategory alloc] initWithContext:context];
    [category parseObject:object];
   
    return category;
}

+ (instancetype)categoryWithCategoryId:(NSString *)categoryId usingContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [ChatRoomCategory fetchRequest];
    [request setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %@", categoryId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error) {
        return nil;
    }
    
    return (ChatRoomCategory *)[result firstObject];
}

- (int16_t)unreadCount {
    int16_t count = 0;
    
    for (ChatRoom *group in [self rooms]) {
        count += [group unreadCount];
    }
    
    return count;
}

- (void)parseObject:(NSDictionary*)object {
    NSString *name = [object objectForKey:@"name"];
    NSString *icon = [object objectForKey:@"icon"];
    NSString *categoryId = [object objectForKey:@"id"];
    
    NSURL *iconUrl = [NSURL URLWithString:icon];
    
    if(![[self name] isEqualToString:name]) {
        [self setName:name];
    }
    if(![[self icon] isEqual:iconUrl]) {
        [self setIcon:iconUrl];
    }
    if(![[self categoryId] isEqualToString:categoryId]) {
        [self setCategoryId:categoryId];
    }
}
@end
