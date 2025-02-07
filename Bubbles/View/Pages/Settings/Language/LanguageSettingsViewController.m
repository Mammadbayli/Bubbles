//
//  LanguageSettingsViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/23/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "LanguageSettingsViewController.h"
#import "LanguageCellNode.h"

#import "TableNode.h"
#import "TextNode.h"
#import "BundleLocalization.h"
#import "Constants.h"
#import "PersistencyManager.h"

@interface LanguageSettingsViewController ()<ASTableDelegate, ASTableDataSource>
@property(strong, nonatomic) TableNode *tableNode;
@end

@implementation LanguageSettingsViewController {
    NSArray *languages;
}

- (TableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[TableNode alloc] init];
        [_tableNode setDataSource:self];
        [_tableNode setDelegate:self];
    }
    
    return _tableNode;
}

- (instancetype)init {
    self = [super initWithNode:[self tableNode]];
    
    if (self) {
        [self setNavTitle:@"settings_language"];
        languages = [[NSBundle mainBundle] localizations];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [languages count];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *langId = languages[[indexPath row]];
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        LanguageCellNode *cell = [[LanguageCellNode alloc] initWithLanguageId:langId];

        return cell;
       };
       
       return cellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode willDisplayRowWithNode:(ASCellNode *)node {
    NSIndexPath *indexPath = [node indexPath];
    NSString *langId = languages[[indexPath row]];
    NSString *selectedLang = [[BundleLocalization sharedInstance] language];
    BOOL selected = [selectedLang isEqualToString:langId];
    
    [(LanguageCellNode *)node setSelected:selected];
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *langId = languages[[indexPath item]];
    
    [[BundleLocalization sharedInstance] setLanguage:langId];
    [[PersistencyManager sharedInstance] saveLanguagePreference:langId];
    [[NSNotificationCenter defaultCenter] postNotificationName:LANGUAGE_DID_CHANGE_NOTIFICATION object:nil userInfo:@{@"langId": langId}];
}

@end

