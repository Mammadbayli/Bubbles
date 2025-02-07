//
//  LanguageCellNode.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/10/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "LanguageCellNode.h"
#import "TextNode.h"
#import "UIColor+NFSColors.h"
#import "BundleLocalization.h"

@implementation LanguageCellNode
- (instancetype)initWithLanguageId:(NSString *)langId {
    self = [super init];
    
    if (self) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:langId];
        [self setTitle:[[locale localizedStringForLanguageCode:langId] capitalizedString]];
        [self setImage:[UIImage imageNamed: [NSString stringWithFormat:@"flag-%@", langId]]];
    }
    
    return self;
}


@end
