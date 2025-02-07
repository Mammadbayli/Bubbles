//
//  AccountViewController.h
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/15/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "ViewController.h"
#import "UserAttribute+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountViewController : ViewController

- (instancetype)initWithUser:(NSString *)username andIsViewingSelf:(BOOL)isViewingSelf;
- (instancetype)initWithUser:(NSString *)username;
@property (strong, nonatomic) NSArray *items;
@property (nonatomic) BOOL isViewingSelf;
- (void)updateVCardForKey:(NSString*)key value:(NSString*)value visible:(BOOL)isVisible;
@property (strong, nonatomic) NSMutableDictionary<NSString*, UserAttribute*> *attributes;

@end

NS_ASSUME_NONNULL_END
