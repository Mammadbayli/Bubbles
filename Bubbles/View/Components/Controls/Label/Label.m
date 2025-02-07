//
//  Label.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 11/10/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "Label.h"
#import "Constants.h"

@implementation Label {
    NSString *loctext;
}

- (void)setText:(NSString *)text {
    loctext = text;
    [super setText:NSLocalizedString(text, nil)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange:) name:LANGUAGE_DID_CHANGE_NOTIFICATION object:nil];
    }
    return self;
}

-(void)languageDidChange: (NSNotification*)notif {
    [self setText:loctext];
}


@end
