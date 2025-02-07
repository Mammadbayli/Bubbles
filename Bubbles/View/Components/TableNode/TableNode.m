//
//  TableNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/24/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "TableNode.h"

@implementation TableNode

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    
    return self;
}

- (void)didLoad {
    [super didLoad];
    
    //Disable last cell separator
    [[self view] setTableFooterView: [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)]];
}

@end
