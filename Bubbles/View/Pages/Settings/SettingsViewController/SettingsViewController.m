//
//  SettingsViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/16/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "SettingsViewController.h"

#import "SettingsItem.h"
#import "TableCellNode.h"
#import "TableNode.h"
#import "LanguageSettingsViewController.h"
#import "AlertPresenter.h"
#import "AlertPresenter.h"
#import "UserSupportViewController.h"
#import "EditLicenseNumberViewController.h"
#import "RegistrationController.h"
#import "Bubbles-Swift.h"

@interface SettingsViewController ()<ASTableDelegate, ASTableDataSource>
@property (strong, nonatomic) TableNode *tableNode;
@end

@implementation SettingsViewController{
    NSArray *items;
}
- (instancetype)init {
    TableNode *tableNode = [[TableNode alloc] init];
    self = [super initWithNode:tableNode];
    if (self) {
        [self setNavTitle:@"settings"];
        
        items = @[
//                  [[SettingsItem alloc] initWithTitle:@"settings_saved_messages" image: [UIImage imageNamed:@"star"]],
//                  [[SettingsItem alloc] initWithTitle:@"settings_change_license_plate" image: [UIImage imageNamed:@"settings_update_license"]],
                  [[SettingsItem alloc] initWithTitle:@"settings_notfications_and_alerts" image: [UIImage imageNamed:@"settings_notification_and_alerts"]],
                  [[SettingsItem alloc] initWithTitle:@"settings_language" image: [UIImage imageNamed:@"settings_language"]],
                  [[SettingsItem alloc] initWithTitle:@"settings_support" image: [UIImage imageNamed:@"settings_support"]],
                  [[SettingsItem alloc] initWithTitle:@"settings_log_out" image: [UIImage imageNamed:@"settings_log_out"]],
                  [[SettingsItem alloc] initWithTitle:@"settings_delete_accountt" image: [UIImage imageNamed:@"settings_delete_account"]]
          ];
        
        _tableNode = tableNode;
        [_tableNode setDataSource:self];
        [_tableNode setDelegate:self];
        [_tableNode setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
   SettingsItem *item = items[[indexPath row]];
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        TableCellNode *cell = [[TableCellNode alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setImage:[item image]];
        [cell setTitle:[item title]];
        
        return cell;
    };
    
    return  cellNodeBlock;
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(CGSizeMake(0, 60));
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([indexPath row] == 0) {
//        [[self navigationController] pushViewController:[SavedMessagesViewContainer create] animated:YES];
//    }
    
//    if ([indexPath row] == 1) {
//        [[self navigationController] pushViewController:[[EditLicenseNumberViewController alloc] init] animated:YES];
//    }
    
    if ([indexPath row] == 0) {
        [[self navigationController] pushViewController:[NotificationSettingsViewContainer create] animated:YES];
    }
    
    if ([indexPath row] == 1) {
        [[self navigationController] pushViewController:[[LanguageSettingsViewController alloc] init] animated:YES];
    }
    
    if ([indexPath row] == 2) {
        [[self navigationController] pushViewController:[[UserSupportViewController alloc] init] animated:YES];
    }
    
    if ([indexPath row] == 3) {
        [[AlertPresenter sharedInstance] presentWithTitle:@"warning"
                                                  message:@"settings_log_out_warning"
                                                    image:nil
                                          hasCancelButton:YES]
        .then(^{
            [[RegistrationController sharedInstance] logOut];
        });
    }
    
    if([indexPath row] == 4) {
        [[AlertPresenter sharedInstance] presentWithTitle:@"warning"
                                                  message:@"delete_account_warning"
                                                    image:nil
                                          hasCancelButton:YES]
        .then(^{
            [[RegistrationController sharedInstance] deleteAccount];
        });
    }
}

@end
