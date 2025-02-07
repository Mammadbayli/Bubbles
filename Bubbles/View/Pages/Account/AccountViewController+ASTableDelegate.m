//
//  AccountViewController+ASTableDelegate.m
//  Bubbles
//
//  Created by Javad on 07.10.21.
//  Copyright © 2021 Javad Mammadbayli. All rights reserved.
//

#import "AccountViewController+ASTableDelegate.h"
#import "AccountCellNode.h"

@implementation AccountViewController (ASTableNodeDelegate)
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return [[self items] count];
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [[self items][section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* section = [[self items] objectAtIndex:[indexPath section]];
    NSString *item = [section objectAtIndex:[indexPath row]];
    UserAttribute *attribute = [[self attributes] objectForKey:item];
    
    typeof(self) __weak weakSelf = self;
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        AccountCellNode *node = [[AccountCellNode alloc] initWithAttribute:attribute
                                                                  andTitle:item
                                                                   andIsEditable:[self isViewingSelf]];

        [node setOnUpdate:^(NSString * _Nonnull text, BOOL isVisible) {
            [weakSelf updateVCardForKey:item value:text visible:isVisible];
        }];
        
        return node;
    };
    
    return cellNodeBlock;
}

@end
